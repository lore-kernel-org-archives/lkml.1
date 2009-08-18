Return-Path: <linux-kernel-owner+w=401wt.eu-S1757726AbZHRJFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757726AbZHRJFJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 05:05:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbZHRJFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 05:05:08 -0400
Received: from cmpxchg.org ([85.214.51.133]:58559 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753149AbZHRJFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 05:05:07 -0400
Date: Tue, 18 Aug 2009 11:04:19 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       stern@rowland.harvard.edu, akpm@linux-foundation.org, apw@canonical.com,
       mingo@elte.hu, linux-kernel@vger.kernel.org, peterz@infradead.org
Subject: Re: [PATCH] Add kerneldoc for flush_scheduled_work()
Message-ID: <20090818090419.GA3730@cmpxchg.org>
References: <13a78aa7-dd27-49d9-8164-d6e802bd4796@default> <20090813145106.GA25333@cmpxchg.org> <1250175853.3901.34.camel@mulgrave.site> <4A843D66.1060407@xenotime.net> <20090813180856.GB26020@cmpxchg.org> <4A85ABBB.5060806@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A85ABBB.5060806@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Randy,

On Fri, Aug 14, 2009 at 11:23:55AM -0700, Randy Dunlap wrote:
> Johannes Weiner wrote:
> > diff --git a/scripts/kernel-doc b/scripts/kernel-doc
> > index b52d340..2921aab 100755
> > --- a/scripts/kernel-doc
> > +++ b/scripts/kernel-doc
> > @@ -281,6 +281,7 @@ my $doc_end = '\*/';
> >  my $doc_com = '\s*\*\s*';
> >  my $doc_decl = $doc_com . '(\w+)';
> >  my $doc_sect = $doc_com . '([' . $doc_special . ']?[\w\s]+):(.*)';
> > +my $doc_cont = $doc_com . '([^@/\s].*)';
> >  my $doc_content = $doc_com . '(.*)';
> >  my $doc_block = $doc_com . 'DOC:\s*(.*)?';
> >  
> > @@ -1995,6 +1996,7 @@ sub process_file($) {
> >      my $identifier;
> >      my $func;
> >      my $descr;
> > +    my $in_purpose = 0;
> >      my $initial_section_counter = $section_counter;
> >  
> >      if (defined($ENV{'SRCTREE'})) {
> > @@ -2044,6 +2046,7 @@ sub process_file($) {
> >  		    $descr =~ s/\s*$//;
> >  		    $descr =~ s/\s+/ /;
> >  		    $declaration_purpose = xml_escape($descr);
> > +		    $in_purpose = 1;
> >  		} else {
> >  		    $declaration_purpose = "";
> >  		}
> > @@ -2075,7 +2078,12 @@ sub process_file($) {
> >  		++$warnings;
> >  		$state = 0;
> >  	    }
> > +	} elsif ($in_purpose == 1 && /$doc_cont/o) {
> > +	    # continued description
> > +	    chomp($declaration_purpose);
> > +	    $declaration_purpose .= " " . $1;
> >  	} elsif ($state == 2) {	# look for head: lines, and include content
> > +	    $in_purpose = 0;
> >  	    if (/$doc_sect/o) {
> >  		$newsection = $1;
> >  		$newcontents = $2;
> 
> Hi Hannes,
> 
> This looks good in theory, but it doesn't survive a "make htmldocs"
> after the patch is applied.
> 
> It could be the ending kernel-doc comment characters:
>  **/
> 
> The problem is in drivers/scsi/scsi_devinfo.c:
> /**
>  * scsi_dev_info_list_delete - called from scsi.c:exit_scsi to remove the scsi_dev_info_list.
>  **/
> void scsi_exit_devinfo(void)
> {
> 
> 
> I'm currently on vacation, but I'll look into it more if you can't
> do so.

Yeah, it's the terminating **/ which matches $doc_cont.  I will try to
send an updated version this evening.

	Hannes
