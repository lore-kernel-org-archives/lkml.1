Return-Path: <linux-kernel-owner+w=401wt.eu-S1762530AbYEFJ4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762530AbYEFJ4A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 05:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753615AbYEFJzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 05:55:50 -0400
Received: from smtp1.wifiinternet.cz ([89.31.47.1]:58016 "EHLO
	bor.wifiinternet.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753197AbYEFJzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 05:55:49 -0400
Message-ID: <48202B63.2050101@seznam.cz>
Date: Tue, 06 May 2008 11:56:51 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: John Williams <john.williams@petalogix.com>
CC: monstr@seznam.cz, linux-kernel@vger.kernel.org, arnd@arndb.de,
       linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca
Subject: Re: [PATCH 24/56] microblaze_v2: time support
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz>	 <d883a8d8da812d77fefd47730d28d0bdb7b504e0.1209897266.git.monstr@monstr.eu>	 <625ef466cf121d655539eedc919dd39166087e0c.1209897266.git.monstr@monstr.eu>	 <b5067a1846075ddd1035966ea1edc908579e2e88.1209897266.git.monstr@monstr.eu>	 <378157891bac535dbc55e658d5f03fdd332e85cf.1209897266.git.monstr@monstr.eu>	 <eadcc6f4754df78b69d6d54c404624d0390c8558.1209897266.git.monstr@monstr.eu>	 <4df4022e06b9056202cc2fdf0b99deb01563a0fa.1209897266.git.monstr@monstr.eu>	 <6b0c9864dc80776ae48d6488a6892e5d698751b7.1209897266.git.monstr@monstr.eu>	 <ea5cbbca49c38c506960fddba29cbd8cb24e1a8d.1209897266.git.monstr@monstr.eu>	 <4f4d6ed3fce9b21cdd6dcacb2d72fff7e9830628.1209897266.git.monstr@monstr.eu>	 <35e662a81eb86c7ffb2aaa6141ca38a07789f382.1209897266.git.monstr@monstr.eu>	 <1209953949.5798.66.camel@localhost>  <481F1830.5090309@seznam.cz> <1210033811.5798.188.camel@localhost>
In-Reply-To: <1210033811.5798.188.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

> Hi Michal,
> 
> On Mon, 2008-05-05 at 16:22 +0200, Michal Simek wrote:
>> Hi John,
>>
>> you wrote me you have smarter implementation that xilinx did. Can you find it
>> and send me it?
> 
> It's not much (any?) better?  One less multiply I think?  Attached
> anyway - feel free to discard for now.
> 
> We could do a nice asm implementation with the optional mulhi
> instruction, but that can wait.
> 
> Cheers,
> 
> John

+extern __inline__ void __udelay(unsigned int x)
 {
-	unsigned long long tmp = usec;
-	unsigned long loops = (tmp * 4295 * HZ * loops_per_jiffy) >> 32;
+	unsigned long long tmp=(unsigned long long)x*(unsigned long
long)loops_per_jiffy*226LL;
+	unsigned loops=tmp>>32;
+
 	__delay(loops);
 }

-#endif /* _ASM_MICROBLAZE_DELAY_H */
+extern __inline__ void __ndelay(unsigned int x)
+{
+	unsigned long long tmp=(unsigned long long)x*(unsigned long
long)loops_per_jiffy*226LL;
+	unsigned loops=tmp>>32;
+
+	__delay(loops);
+}

Why is __ndelay implementation the same with __udelay? This is weird for me.

+
+extern void __bad_udelay(void);		/* deliberately undefined */
+extern void __bad_ndelay(void);		/* deliberately undefined */

Are these function used anywhere?

+#define udelay(n) (__builtin_constant_p(n)? \
+	((n) > __MAX_UDELAY? __bad_udelay(): __udelay((n) * (19 * HZ))) : \
+	__udelay((n) * (19 * HZ)))
+
+#define ndelay(n) (__builtin_constant_p(n)? \
+	((n) > __MAX_NDELAY? __bad_ndelay(): __ndelay((n) * HZ)) : \
+	__ndelay((n) * HZ))

+#define muldiv(a, b, c)    (((a)*(b))/(c))

muldiv: Where is this use?

Michal
