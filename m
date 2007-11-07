Return-Path: <linux-kernel-owner+w=401wt.eu-S1754675AbXKGLDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675AbXKGLDz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 06:03:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751851AbXKGLDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 06:03:47 -0500
Received: from smtpoutm.mac.com ([17.148.16.70]:57791 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751209AbXKGLDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 06:03:46 -0500
X-Greylist: delayed 430 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Nov 2007 06:03:46 EST
In-Reply-To: <alpine.LFD.0.999.0711060742100.15101@woody.linux-foundation.org>
References: <472B8DAF.9080706@schaufler-ca.com> <20071103164303.GA26707@ubuntu> <20071106063305.GA26163@stusta.de> <C1C917F8-57EA-434C-9FD8-CB5A4EAF2653@mac.com> <20071106085651.GC26163@stusta.de> <20071106113359.GA6041@ubuntu> <20071106114738.GH26163@stusta.de> <1865922a0711060423ue81dbdct413b993e727f6f9@mail.gmail.com> <46B300CD-7A35-4E81-A0AE-EC2BB72016DD@mac.com> <alpine.LFD.0.999.0711060742100.15101@woody.linux-foundation.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: multipart/mixed; boundary=Apple-Mail-7--770082975
Message-Id: <DF41BB75-679F-4B6A-90F3-77DF228B6D3D@mac.com>
Cc: "Ahmed S. Darwish" <darwish.07@gmail.com>, Adrian Bunk <bunk@kernel.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-security-module@vger.kernel.org,
       LKML Kernel <linux-kernel@vger.kernel.org>
From: Kyle Moffett <mrlinuxman@mac.com>
Subject: [PATCH] Fix isspace() and other ctype.h functions to ignore chars 128-255
Date: Wed, 7 Nov 2007 05:56:05 -0500
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--Apple-Mail-7--770082975
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=US-ASCII;
	delsp=yes;
	format=flowed

Originally isspace() and other similar functions in ctype.h ignored  
any character with the high bit set; however this was changed during  
the linux 2.1 days to map Latin-1.  As following Latin-1 will most  
likely break UTF-8 any any *other* encoding that is backwards- 
compatible with 7-bit-ASCII, change ctype.c to ignore such characters  
completely (the way they were before).  Linus seems to think this is  
a good thing, and he's the one that wrote the code in the first place.

Signed-off-by: Kyle Moffett <mrlinuxman@mac.com>

---

On Nov 06, 2007, at 10:53:08, Linus Torvalds wrote:
> On Tue, 6 Nov 2007, Kyle Moffett wrote:
>> Personally I think that isspace() accepting character 0xA0 is a bug
>
> I think I agree with you. As far as the kernel is concerned,  
> "isspace()" should just accept the obvious spaces (hardspace, tab,  
> newline), and *perhaps* the VT/FF kind of things.
>
> You should realize that the kernel <ctype.h> thing is *ancient*.  
> It's basically there from v0.01, and while the really original one  
> (I just checked) had all the non-ascii characters not trigger  
> anything, it was converted to be latin1 in the 2.1.x timeframe.
>
> That's a *loong* time ago. Way before UTF-8 and other things were  
> really common.
>
> So we should probably just make all the upper 128 bytes go back to  
> "don't trigger anything in ctype.h" - they'd not be spaces, but  
> they'd not be control characters or anything else either.


--Apple-Mail-7--770082975
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	x-unix-mode=0644;
	name=fix-isspace-patch.txt
Content-Disposition: attachment;
	filename=fix-isspace-patch.txt

 lib/ctype.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/lib/ctype.c b/lib/ctype.c
index d02ace1..ce2807a 100644
--- a/lib/ctype.c
+++ b/lib/ctype.c
@@ -24,13 +24,18 @@ _P,_L|_X,_L|_X,_L|_X,_L|_X,_L|_X,_L|_X,_L,	/* 96-103 */
 _L,_L,_L,_L,_L,_L,_L,_L,			/* 104-111 */
 _L,_L,_L,_L,_L,_L,_L,_L,			/* 112-119 */
 _L,_L,_L,_P,_P,_P,_P,_C,			/* 120-127 */
+
+/*
+ * None of these match any type bits to avoid screwing up UTF-8 or any other
+ * 7-bit-ASCII-compatible encoding.
+ */
 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,		/* 128-143 */
 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,		/* 144-159 */
-_S|_SP,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,   /* 160-175 */
-_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,_P,       /* 176-191 */
-_U,_U,_U,_U,_U,_U,_U,_U,_U,_U,_U,_U,_U,_U,_U,_U,       /* 192-207 */
-_U,_U,_U,_U,_U,_U,_U,_P,_U,_U,_U,_U,_U,_U,_U,_L,       /* 208-223 */
-_L,_L,_L,_L,_L,_L,_L,_L,_L,_L,_L,_L,_L,_L,_L,_L,       /* 224-239 */
-_L,_L,_L,_L,_L,_L,_L,_P,_L,_L,_L,_L,_L,_L,_L,_L};      /* 240-255 */
+0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,		/* 160-175 */
+0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,		/* 176-191 */
+0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,		/* 192-207 */
+0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,		/* 208-223 */
+0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,		/* 224-239 */
+0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};		/* 240-255 */
 
 EXPORT_SYMBOL(_ctype);

--Apple-Mail-7--770082975
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed



--Apple-Mail-7--770082975--
