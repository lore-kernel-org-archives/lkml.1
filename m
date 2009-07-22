Return-Path: <linux-kernel-owner+w=401wt.eu-S1755481AbZGVKXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481AbZGVKXq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 06:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753832AbZGVKXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 06:23:45 -0400
Received: from mail6.webfaction.com ([74.55.86.74]:58390 "EHLO
	smtp.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924AbZGVKXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 06:23:43 -0400
Date: Wed, 22 Jul 2009 11:24:04 +0100 (BST)
From: Troy Moure <twmoure@szypr.net>
To: Krzysztof Oledzki <olel@ans.pl>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Troy Moure <twmoure@szypr.net>, Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
       lwn@lwn.net, Ian Lance Taylor <iant@google.com>
Subject: Re: Linux 2.6.27.27
In-Reply-To: <alpine.LNX.1.10.0907221022380.26357@bizon.gios.gov.pl>
Message-ID: <alpine.LFD.2.00.0907221123480.11527@troy-laptop>
References: <20090720040655.GA11940@kroah.com> <4A645A45.9060509@ans.pl> <20090720151008.GC10015@suse.de> <alpine.LFD.2.01.0907200848530.13838@localhost.localdomain> <alpine.LNX.1.10.0907202341580.29729@bizon.gios.gov.pl> <alpine.LFD.2.01.0907201504470.19335@localhost.localdomain>
 <alpine.LNX.1.10.0907210831210.29729@bizon.gios.gov.pl> <alpine.LNX.1.10.0907211154480.29729@bizon.gios.gov.pl> <alpine.LFD.2.01.0907210906400.19335@localhost.localdomain> <alpine.LFD.2.01.0907211133010.19335@localhost.localdomain>
 <alpine.LFD.2.00.0907212211040.4630@troy-laptop> <alpine.LFD.2.01.0907211726140.19335@localhost.localdomain> <alpine.LFD.2.01.0907211811410.19335@localhost.localdomain> <alpine.LNX.1.10.0907220914150.26357@bizon.gios.gov.pl>
 <alpine.LNX.1.10.0907221022380.26357@bizon.gios.gov.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LFD.2.00.0907221056561.11527@troy-laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 22 Jul 2009, Krzysztof Oledzki wrote:
> > 
> > Indeed, this simple change is enough to make my kernel bootable. However,
> > there is still something wrong. My console is now 80x30 instead of 128x48:
> > 
> > -Console: switching to colour frame buffer device 128x48
> > +Console: switching to colour frame buffer device 80x30
> > 
> > So, it looks like the loop may be still miscompiled.
> > 

Yes.  I took a look at the -fixed binary you sent out.  edid_checksum() is 
now compiled to this (I added some notes on the side):

ffffffff803b37ed: <edid_checksum>:
       53                      push   %rbx
       48 89 fb                mov    %rdi,%rbx		   %ebx = edid

	[... Calls to check_edid and fix_edid ... ]

       31 c9                   xor    %ecx,%ecx		   csum = 0
       31 f6                   xor    %esi,%esi		   all_null = 0
       31 d2                   xor    %edx,%edx		   i = 0
 L:    0f b6 04 1a             movzbl (%rdx,%rbx,1),%eax   %eax = *(i + edid)
       48 ff c2                inc    %rdx		   i++
       01 c1                   add    %eax,%ecx		   csum += %eax
       09 c6                   or     %eax,%esi		   all_null |= %eax
       48 81 fa 80 00 00 00    cmp    $0x80,%rdx
       75 ec                   jne    L			   if i != 80 goto L
       85 c9                   test   %ecx,%ecx
       0f 94 c0                sete   %al		%al == (csum == 0)
       85 f6                   test   %esi,%esi
       5b                      pop    %rbx
       0f 95 c2                setne  %dl		%dl == (all_null == 0)
       21 d0                   and    %edx,%eax
       0f b6 c0                movzbl %al,%eax		%eax == (%al && %dl)
       c3                      retq			return %eax

The problem is that csum is stored in %ecx (a 32-bit register) at all 
times and is never truncated to a byte.  In other words, the compiler is 
treating csum like it's an 'int', not an 'unsigned char'.

> Here is a diff between a good and a bad kernel:
> 
> -edid_checksum debug: csum=0, all_null=255, err=1
> -edid_checksum debug: csum=0, all_null=255, err=1
> -Console: switching to colour frame buffer device 128x48
> +edid_checksum debug: csum=6400, all_null=255, err=0
> +Console: switching to colour frame buffer device 80x30
> 
> In the good one the function is called twice and it returns err=1 (==OK). In
> the bad kernel it returns 0 because csum!=0x00 (==6400).

That makes sense - since csum is being treated like an 'int', it never 
wraps, so it just ends up holding the total sum of all the bytes, which 
apparently is 6400.  Notice that 6400 % 256 == 0, so if it *had* wrapped, 
it would have ended up being 0, as expected.

One "fix" might be to just make 'csum' an 'int' (since that's what the 
compiler seems to think anyway :p) and do the wrapping by hand (patch 
below, if you want to try this).

However, I wouldn't be surprised if other kernel functions are also being 
miscompiled.  It seems to me that any function that does arithmetic on 
'unsigned char's and depends on the wrapping behaviour could potentially 
be broken... 

Best regards,

	Troy

diff --git a/drivers/video/fbmon.c b/drivers/video/fbmon.c
index 5c1a2c0..6802b4c 100644
--- a/drivers/video/fbmon.c
+++ b/drivers/video/fbmon.c
@@ -256,8 +256,8 @@ static void fix_edid(unsigned char *edid, int fix)
 
 static int edid_checksum(unsigned char *edid)
 {
-	unsigned char i, csum = 0, all_null = 0;
-	int err = 0, fix = check_edid(edid);
+	unsigned char all_null = 0;
+	int i, csum = 0, err = 0, fix = check_edid(edid);
 
 	if (fix)
 		fix_edid(edid, fix);
@@ -267,7 +267,7 @@ static int edid_checksum(unsigned char *edid)
 		all_null |= edid[i];
 	}
 
-	if (csum == 0x00 && all_null) {
+	if ((csum & 0xff) == 0x00 && all_null) {
 		/* checksum passed, everything's good */
 		err = 1;
 	}
