Return-Path: <linux-kernel-owner+w=401wt.eu-S1753469AbZHSXVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbZHSXVn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 19:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbZHSXVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 19:21:43 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:19111 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275AbZHSXVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 19:21:42 -0400
Message-ID: <4A8C88F3.1000609@oracle.com>
Date: Wed, 19 Aug 2009 16:21:23 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       stern@rowland.harvard.edu, akpm@linux-foundation.org, apw@canonical.com,
       mingo@elte.hu, linux-kernel@vger.kernel.org, peterz@infradead.org
Subject: Re: [PATCH] Add kerneldoc for flush_scheduled_work()
References: <13a78aa7-dd27-49d9-8164-d6e802bd4796@default> <20090813145106.GA25333@cmpxchg.org> <1250175853.3901.34.camel@mulgrave.site> <4A843D66.1060407@xenotime.net> <20090813180856.GB26020@cmpxchg.org> <4A85ABBB.5060806@oracle.com> <20090818090419.GA3730@cmpxchg.org> <20090819222357.GA12821@cmpxchg.org>
In-Reply-To: <20090819222357.GA12821@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt005.oracle.com [141.146.116.14]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4A8C88CB.013A:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner wrote:
>> Yeah, it's the terminating **/ which matches $doc_cont.  I will try to
>> send an updated version this evening.
> 
> I got completely rid of the extra re.  Just parse a non-empty content
> line following the declaration purpose immediately as continuation.
> 
> It survives make htmldocs, the scsi_exit_devinfo() doc looks okay and
> for stuff that had continuation lines before, it does what's expected
> - e.g. for the doc of kernel/sched.c::init_sd_power_savings_stats().
> 
> It behaves differently for broken docs
> (mm/page_alloc.c::calculate_zone_inactive_ratio e.g.), but that
> shouldn't matter.

Right, no problem on that one (for which I sent Andrew a patch some
time ago).

> I didn't find any other misbehaviour when checking random samples.

It's very close.  I only checked/compared one docbook: mac80211.
There is some kind of paragraph end handling difference.

In processing include/net/mac80211.h, struct ieee80211_tx_info,
without the patch, it ends with:

This structure is placed in skb->cb for three uses: (1) mac80211 TX control - mac80211 tells the driver what to do (2) driver internal use (if applicable) (3) TX status information - driver tells mac80211 what happened

The TX control's sta pointer is only valid during the ->tx call, it may be NULL.

and with the patch, those 2 paragraphs are run together:

This structure is placed in skb->cb for three uses: (1) mac80211 TX control - mac80211 tells the driver what to do (2) driver internal use (if applicable) (3) TX status information - driver tells mac80211 what happened The TX control's sta pointer is only valid during the ->tx call, it may be NULL.



I don't think that this will be difficult to find/fix...

Thanks.

> ---
> From: Johannes Weiner <hannes@cmpxchg.org>
> Subject: kernel-doc: allow multi-line declaration purpose descriptions
> 
> Allow the short description after symbol name and dash in a kernel-doc
> comment to span multiple lines, e.g. like this:
> 
> 	/**
> 	 * unmap_mapping_range - unmap the portion of all mmaps in the
> 	 *	specified address_space corresponding to the specified
> 	 *	page range in the underlying file.
> 	 * @mapping: the address space containing mmaps to be unmapped.
> 	 * ...
> 	 */
> 
> The short description ends with a parameter description, an empty line
> or the end of the comment block.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  Documentation/kernel-doc-nano-HOWTO.txt |    4 +++-
>  scripts/kernel-doc                      |   19 ++++++++++++++-----
>  2 files changed, 17 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/kernel-doc-nano-HOWTO.txt b/Documentation/kernel-doc-nano-HOWTO.txt
> index 4d04572..348b9e5 100644
> --- a/Documentation/kernel-doc-nano-HOWTO.txt
> +++ b/Documentation/kernel-doc-nano-HOWTO.txt
> @@ -66,7 +66,9 @@ Example kernel-doc function comment:
>   * The longer description can have multiple paragraphs.
>   */
>  
> -The first line, with the short description, must be on a single line.
> +The short description following the subject can span multiple lines
> +and ends with an @argument description, an empty line or the end of
> +the comment block.
>  
>  The @argument descriptions must begin on the very next line following
>  this opening short function description line, with no intervening
> diff --git a/scripts/kernel-doc b/scripts/kernel-doc
> index b52d340..6194ef5 100755
> --- a/scripts/kernel-doc
> +++ b/scripts/kernel-doc
> @@ -1995,6 +1995,7 @@ sub process_file($) {
>      my $identifier;
>      my $func;
>      my $descr;
> +    my $in_purpose = 0;
>      my $initial_section_counter = $section_counter;
>  
>      if (defined($ENV{'SRCTREE'})) {
> @@ -2044,6 +2045,7 @@ sub process_file($) {
>  		    $descr =~ s/\s*$//;
>  		    $descr =~ s/\s+/ /;
>  		    $declaration_purpose = xml_escape($descr);
> +		    $in_purpose = 1;
>  		} else {
>  		    $declaration_purpose = "";
>  		}
> @@ -2090,6 +2092,7 @@ sub process_file($) {
>  		}
>  
>  		$in_doc_sect = 1;
> +		$in_purpose = 0;
>  		$contents = $newcontents;
>  		if ($contents ne "") {
>  		    while ((substr($contents, 0, 1) eq " ") ||
> @@ -2119,11 +2122,17 @@ sub process_file($) {
>  	    } elsif (/$doc_content/) {
>  		# miguel-style comment kludge, look for blank lines after
>  		# @parameter line to signify start of description
> -		if ($1 eq "" &&
> -			($section =~ m/^@/ || $section eq $section_context)) {
> -		    dump_section($file, $section, xml_escape($contents));
> -		    $section = $section_default;
> -		    $contents = "";
> +		if ($1 eq "") {
> +		    if ($section =~ m/^@/ || $section eq $section_context) {
> +			dump_section($file, $section, xml_escape($contents));
> +			$section = $section_default;
> +			$contents = "";
> +		    }
> +		    $in_purpose = 0;
> +		} elsif ($in_purpose == 1) {
> +		    # Continued declaration purpose
> +		    chomp($declaration_purpose);
> +		    $declaration_purpose .= " " . $1;
>  		} else {
>  		    $contents .= $1 . "\n";
>  		}

