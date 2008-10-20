Return-Path: <linux-kernel-owner+w=401wt.eu-S1752397AbYJTJSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397AbYJTJSm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 05:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232AbYJTJSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 05:18:35 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:41257 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbYJTJSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 05:18:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=J05wpspV8rGtqkw7EHfEmeuB84mmqMRezy3m5lTqcSoVgSLY4xyXZspDV8eM1hdSEw
         fsoqfj3bX9okf6cNzRdY4Ukt1G6MuM1o+19q7POJkdX6fR7V09ejzL/8yQAhbyrULjq/
         fbzpLztTmKUesfQfShM2zwBAss5vb8zvY/wPI=
Message-ID: <787b0d920810200218o5f26ee7bj9f8c0e71606dd5cb@mail.gmail.com>
Date: Mon, 20 Oct 2008 05:18:32 -0400
From: "Albert Cahalan" <acahalan@gmail.com>
To: "Mel Gorman" <mel@csn.ul.ie>, adobriyan@gmail.com,
       kosaki.motohiro@jp.fujitsu.com,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] Report the size of pages backing VMAs in /proc V3
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding " (hpagesize=4096kB)" onto the end of a filename is as vile
as adding " (deleted)" onto the end. If anything is going to change
in this area, it should be the elimination of " (deleted)". These
tags are perfectly legitimate in filenames.

Looping on stat() while chopping off suspected tags is dreadful.
Besides just being gross, it's slow.

gdb will tolerate up to 7 flags, procps will tolerate up to 31 flags,
and both will tolerate anything without a '/' before the filename.

Obviously, every author of a /proc-based tool has been forced to
take a random guess at the ABI. The /proc/*/smaps is so gross and
that I put off writing a parser for years.

What you can probably get away with:

After the "rwxp" stuff you can add 3 more flags. (gdb limit)
You could use 'L' for locked pages, 'R' for swap reservation,
and 'D' for deleted files. It's probably much better to save
space though, since gdb will crash if you add too many flags.
Three characters can be 18 bits if you base-64 encode them,
being careful to avoid the '/' character. (adding 0x30 works)

Right before the filename, you can add anything except a '/'.
You could add a few columns of numbers or a second flags field.

Not that it matters on such a slow-ass file format, but you
can make parsing faster if you encode the page size in one byte.
Simply add 0x30 to the page shift, then print that byte. Note that
this would let you cram the page size into the flags field.

BTW, I'm thinking that the /proc/*/*maps files fail when the
lines exceed 4096 bytes. The pathname may legitimately be that
long, plus it can be backslash escaped, plus there is all the
junk on the beginning.
