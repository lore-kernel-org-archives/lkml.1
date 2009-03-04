Return-Path: <linux-kernel-owner+w=401wt.eu-S1756006AbZCDXwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006AbZCDXwi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 18:52:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752845AbZCDXw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 18:52:26 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:3815 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbZCDXwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 18:52:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=HTQbliLcT7mp5jMsnfm5laxEUNG26FpSFOYUU6Ufl3U4D4KU4w+YodaqRcVXX7DRI3
         Y2vmztfYpF4PwshhFclpc5yjsOufUpksjOAxqQAZaZcKwaxtrGmfYF1ycgV2kgUQcmtr
         3B9vPnHer4sL/4Bo0Wk4PTUC/mkNXvKWpPyhs=
Message-ID: <49AF1429.9080009@gmail.com>
Date: Wed, 04 Mar 2009 23:52:09 +0000
From: Dave <kilroyd@googlemail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090104)
MIME-Version: 1.0
To: Jakub Narebski <jnareb@gmail.com>
CC: Pavel Roskin <proski@gnu.org>, git@vger.kernel.org,
       linux-kernel@vger.kernel.org, orinoco-users@lists.sourceforge.net,
       dwmw2@infradead.org
Subject: Re: [Orinoco-users] linux-firmware binary corruption with gitweb
References: <49A98F6A.50702@gmail.com> <1235886467.3195.15.camel@mj>	<49AD7E2B.3010101@gmail.com> <m3iqmqt9ox.fsf@localhost.localdomain>
In-Reply-To: <m3iqmqt9ox.fsf@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jakub Narebski wrote:
> Dave <kilroyd@googlemail.com> writes:
>>> My strong impression is that the recoding takes place on the server.  I
>>> think the bug should be reported to the gitweb maintainers unless it a
>>> local breakage on the kernel.org site.
>> Thanks Pavel.
>>
>> I just did a quick scan of the gitweb README - is this an issue with the
>> $mimetypes_file or $fallback_encoding configurations variables?
> 
> First, what version of gitweb do you use? It should be in 'Generator'
> meta header, or (in older gitweb) in comments in HTML source at the
> top of the page.

Not sure where I'd find the meta header, but at the top of the HTML:

<!-- git web interface version 1.4.5-rc0.GIT-dirty, (C) 2005-2006, Kay
Sievers <kay.sievers@vrfy.org>, Christian Gierke -->
<!-- git core binaries version 1.6.1.1 -->

> Second, the file is actually sent to browser 'as is', using binmode :raw
> (or at least should be according to my understanding of Perl). And *.bin
> binary file gets application/octet-stream mimetype, and doesn't send any
> charset info. git.kernel.org should have modern enough gitweb to use this.
> Strange...

Dug around gitweb.perl in the main git repo. Then looked at the
git/warthog9/gitweb.git repo (after noting the Git Wiki says kernel.org
is running John Hawley's branch).

One notable change to git_blob_plain:

        undef $/;
        binmode STDOUT, ':raw';
-        print <$fd>;
+        #print <$fd>;
+        $output .= <$fd>;
        binmode STDOUT, ':utf8'; # as set at the beginning of gitweb.cgi
        $/ = "\n";

        close $fd;
+
+        return $output;

If that's the code that's running, doesn't that mean the output mode
change doesn't impact the concatenation to $output? So the blob gets utf
encoding when actually printed.


Regards,

Dave.
