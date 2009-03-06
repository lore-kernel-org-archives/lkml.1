Return-Path: <linux-kernel-owner+w=401wt.eu-S1757143AbZCFAD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143AbZCFAD4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 19:03:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755035AbZCFADs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 19:03:48 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:61706 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754293AbZCFADr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 19:03:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=bS9ZkQEd9a9iN6ScqSq5s7+kh0Ir2j6lmkY6XZRxVUyTeEC1+INmPAEOWIekB4bJOJ
         yA3rR6fo1CeT0/dXg38y36mCvFK99/oh55qoGi2iZoO8IOE4j/VCYRMgAJhvc1xj2aSx
         KybgHpLA2EfmQvIz5qNglTm7uFi8dIU7Lgzic=
From: Jakub Narebski <jnareb@gmail.com>
To: Dave <kilroyd@googlemail.com>
Subject: Re: [Orinoco-users] linux-firmware binary corruption with gitweb
Date: Fri, 6 Mar 2009 01:03:30 +0100
User-Agent: KMail/1.9.3
Cc: Pavel Roskin <proski@gnu.org>, git@vger.kernel.org,
       linux-kernel@vger.kernel.org, orinoco-users@lists.sourceforge.net,
       dwmw2@infradead.org, "J.H." <warthog19@eaglescrag.net>
References: <49A98F6A.50702@gmail.com> <m3iqmqt9ox.fsf@localhost.localdomain> <49AF1429.9080009@gmail.com>
In-Reply-To: <49AF1429.9080009@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903060103.32653.jnareb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 March 2009, Dave wrote:
> Jakub Narebski wrote:
>> Dave <kilroyd@googlemail.com> writes:

>>>> My strong impression is that the recoding takes place on the server.  I
>>>> think the bug should be reported to the gitweb maintainers unless it a
>>>> local breakage on the kernel.org site.

It is on server, but kernel.org runs modified version of gitweb, and
the bug is in the modifications.  See below.

CC-ed John 'Warthog9' Hawley, maintainer of gitweb on kernel.org

>>>>
>>> Thanks Pavel.
>>>
>>> I just did a quick scan of the gitweb README - is this an issue with the
>>> $mimetypes_file or $fallback_encoding configurations variables?
>> 
>> First, what version of gitweb do you use? It should be in 'Generator'
>> meta header, or (in older gitweb) in comments in HTML source at the
>> top of the page.
> 
> Not sure where I'd find the meta header,

<meta name="generator" content="gitweb/1.4.5-rc0.GIT-dirty git/1.6.1.1"/>

> but at the top of the HTML: 
> 
> <!-- git web interface version 1.4.5-rc0.GIT-dirty, (C) 2005-2006, Kay
> Sievers <kay.sievers@vrfy.org>, Christian Gierke -->
> <!-- git core binaries version 1.6.1.1 -->

The question was if it is extremely old version of gitweb, without fix
of raw blob ('blob_plain') output for non-utf8, non-text files. But the
answer is that it is _modified_ version of gitweb, see below.

> 
>> Second, the file is actually sent to browser 'as is', using binmode :raw
>> (or at least should be according to my understanding of Perl). And *.bin
>> binary file gets application/octet-stream mimetype, and doesn't send any
>> charset info. git.kernel.org should have modern enough gitweb to use this.
>> Strange...
> 
> Dug around gitweb.perl in the main git repo. Then looked at the
> git/warthog9/gitweb.git repo (after noting the Git Wiki says kernel.org
> is running John Hawley's branch).
> 
> One notable change to git_blob_plain:
> 
>         undef $/;
>         binmode STDOUT, ':raw';
> -        print <$fd>;
> +        #print <$fd>;
> +        $output .= <$fd>;
>         binmode STDOUT, ':utf8'; # as set at the beginning of gitweb.cgi
>         $/ = "\n";
> 
>         close $fd;
> +
> +        return $output;
> 
> If that's the code that's running, doesn't that mean the output mode
> change doesn't impact the concatenation to $output? So the blob gets utf
> encoding when actually printed.

That is the culprit. kernel.org runs modified version of gitweb, with
added caching.  I guess that the above change was to have 'blob_plain'
output cached... but it loses "rawness", and I guess it also loses
mimetype info (unless "print $cgi->header(...)" is also changed to
appending to $output).

One possible solution would be to redirect STDOUT to scalar, and return
that scalar; do that always when caching _output_, and print :raw all
cached _output_ data.
    close STDOUT;
    open STDOUT, '>', \$output or die "Can't open STDOUT: $!";


BTW. f5aa79d (gitweb: safely output binary files for 'blob_plain' action)
was my third patch for git...

-- 
Jakub Narebski
Poland
