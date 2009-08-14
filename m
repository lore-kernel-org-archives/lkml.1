Return-Path: <linux-kernel-owner+w=401wt.eu-S1755845AbZHNSYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845AbZHNSYI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 14:24:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754395AbZHNSYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 14:24:08 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:24027 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424AbZHNSYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 14:24:07 -0400
Message-ID: <4A85ABBB.5060806@oracle.com>
Date: Fri, 14 Aug 2009 11:23:55 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, stern@rowland.harvard.edu,
       akpm@linux-foundation.org, apw@canonical.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, peterz@infradead.org
Subject: Re: [PATCH] Add kerneldoc for flush_scheduled_work()
References: <13a78aa7-dd27-49d9-8164-d6e802bd4796@default> <20090813145106.GA25333@cmpxchg.org> <1250175853.3901.34.camel@mulgrave.site> <4A843D66.1060407@xenotime.net> <20090813180856.GB26020@cmpxchg.org>
In-Reply-To: <20090813180856.GB26020@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt002.oracle.com [141.146.116.11]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4A85AB9B.014F:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner wrote:
> On Thu, Aug 13, 2009 at 09:20:54AM -0700, Randy Dunlap wrote:
>> James Bottomley wrote:
>>> On Thu, 2009-08-13 at 16:51 +0200, Johannes Weiner wrote:
>>>> Okay, I came up with a syntax to allow continued lines in short
>>>> descriptions and parameter descriptons.
>>>>
>>>> I can successfully parse
>>>>
>>>> ---
>>>> /**
>>>>  *	get_tty_driver		-	find device of a tty
>>>>  *					...and everything
>>> I'm not so keen on the ... syntax ... suggestions below
>> I like this even less than James does.
> 
> Fair enough.
> 
>>>> diff --git a/scripts/kernel-doc b/scripts/kernel-doc
>>>> index b52d340..e427b0a 100755
>>>> --- a/scripts/kernel-doc
>>>> +++ b/scripts/kernel-doc
>>>> @@ -279,6 +279,7 @@ my $doc_special = "\@\%\$\&";
>>>>  my $doc_start = '^/\*\*\s*$'; # Allow whitespace at end of comment start.
>>>>  my $doc_end = '\*/';
>>>>  my $doc_com = '\s*\*\s*';
>>>> +my $doc_cont = $doc_com . '\.\.\.\s*(.+)';
>>> how about making this
>>>
>>> $doc_cont = $doc_com.'\s*([^@].*)';
>>>
>>> That way anything that doesn't begin with a variable declaration would
>>> be treated as comment continuation.  Might need a \s is the brackets to
>>> ensure blank lines are OK and not treated as continuations.
> 
> The \s comes from $doc_com already.  We need the [^\s] as you said to
> skip empty lines but also the slash for this one:
> 
> 	* @foo: yada
> 	*/
> 
>> The goal should be to accept what is currently in the kernel source tree IMO,
>> and this suggestion looks like it would support that.
> 
> Yeah.  I also noticed that multi-line blocks starting with @foo: are
> already handled, making the indirect referencing unnecessary.  The
> result is a bit simpler and more straight-forward, I think.
> 
> 	Hannes
> 
> --
> From: Johannes Weiner <hannes@cmpxchg.org>
> Subject: kernel-doc: allow multi-line declaration purpose descriptions
> 
> Allow the short description after symbol name and dash in a kernel-doc
> comment to span multiple lines, like this:
> 
> 	/**
> 	 * unmap_mapping_range - unmap the portion of all mmaps in the
> 	 *	specified address_space corresponding to the specified
> 	 *	page range in the underlying file.
> 	 * @mapping: the address space containing mmaps to be unmapped.
> 	 * ...
> 	 */
> 
> The short description ends with a newline, a parameter description or
> the end of the comment block.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
> 
> diff --git a/scripts/kernel-doc b/scripts/kernel-doc
> index b52d340..2921aab 100755
> --- a/scripts/kernel-doc
> +++ b/scripts/kernel-doc
> @@ -281,6 +281,7 @@ my $doc_end = '\*/';
>  my $doc_com = '\s*\*\s*';
>  my $doc_decl = $doc_com . '(\w+)';
>  my $doc_sect = $doc_com . '([' . $doc_special . ']?[\w\s]+):(.*)';
> +my $doc_cont = $doc_com . '([^@/\s].*)';
>  my $doc_content = $doc_com . '(.*)';
>  my $doc_block = $doc_com . 'DOC:\s*(.*)?';
>  
> @@ -1995,6 +1996,7 @@ sub process_file($) {
>      my $identifier;
>      my $func;
>      my $descr;
> +    my $in_purpose = 0;
>      my $initial_section_counter = $section_counter;
>  
>      if (defined($ENV{'SRCTREE'})) {
> @@ -2044,6 +2046,7 @@ sub process_file($) {
>  		    $descr =~ s/\s*$//;
>  		    $descr =~ s/\s+/ /;
>  		    $declaration_purpose = xml_escape($descr);
> +		    $in_purpose = 1;
>  		} else {
>  		    $declaration_purpose = "";
>  		}
> @@ -2075,7 +2078,12 @@ sub process_file($) {
>  		++$warnings;
>  		$state = 0;
>  	    }
> +	} elsif ($in_purpose == 1 && /$doc_cont/o) {
> +	    # continued description
> +	    chomp($declaration_purpose);
> +	    $declaration_purpose .= " " . $1;
>  	} elsif ($state == 2) {	# look for head: lines, and include content
> +	    $in_purpose = 0;
>  	    if (/$doc_sect/o) {
>  		$newsection = $1;
>  		$newcontents = $2;

Hi Hannes,

This looks good in theory, but it doesn't survive a "make htmldocs"
after the patch is applied.

It could be the ending kernel-doc comment characters:
 **/

The problem is in drivers/scsi/scsi_devinfo.c:
/**
 * scsi_dev_info_list_delete - called from scsi.c:exit_scsi to remove the scsi_dev_info_list.
 **/
void scsi_exit_devinfo(void)
{


I'm currently on vacation, but I'll look into it more if you can't
do so.

Thanks.
