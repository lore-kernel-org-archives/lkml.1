Return-Path: <linux-kernel-owner+w=401wt.eu-S1752515AbZKHNQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515AbZKHNQq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 08:16:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751237AbZKHNQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 08:16:45 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:33385 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbZKHNQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 08:16:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=b60merupndNZMpvug/ffeqeA5V7m4ZlV970stWctD1PLDS0LgCkZ0XJRIylQaQy/D9
         rcH4kHpqezNsNERuwg70P5K70vud6PLrvmKyLLnq8d+HLerX1rWdFX9mUDFcSyh254si
         JmGGMyzPwp6loUV7Ji+VaPXlQZd/IEv0M6EbU=
Date: Sun, 8 Nov 2009 16:16:45 +0300
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: tip tree build warning
Message-ID: <20091108131645.GD5300@lenovo>
References: <20091028181443.50a09dbb.sfr@canb.auug.org.au> <20091028073145.GD6353@elte.hu> <20091028184126.b5f52d1b.sfr@canb.auug.org.au> <20091028184851.504752ef.sfr@canb.auug.org.au> <20091028075012.GD19402@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091028075012.GD19402@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Wed, Oct 28, 2009 at 08:50:12AM +0100]
| 
| * Stephen Rothwell <sfr@canb.auug.org.au> wrote:
| 
| > Hi all,
| > 
| > On Wed, 28 Oct 2009 18:41:26 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
| > >
| > > static inline physid_mask_t default_apicid_to_cpu_present(int phys_apicid)
| > > {
| > >         return physid_mask_of_physid(phys_apicid);
| > > }
| > 
| > I just noticed that this function (default_apicid_to_cpu_present) is 
| > declared "static inline in a header" but looks like it is only used by 
| > assigning its address to a function pointer.  Its only use for x86_64 
| > is in arch/x86/kernel/apic/apic_noop.c ...
| 
| yes, that might be a real problem - returning the mask like that is 
| messy. Thanks, will check.
| 
| 	Ingo
| 

Darn, my fault sorry! Here is an update which fixes the issue.
(Btw, Stephen could you CC me next time if you get commit id
 with me in authors, so I wouldn't miss problem).

Please review, comments/complains are quite welcome!

	-- Cyrill
---
x86,apic: Get rid of apicid_to_cpu_present assign on X86-64

In fact it's never get used on x86-64 (for 64 bit platform
we use differ technique to enumerate io-units).

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/kernel/apic/apic_noop.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6.git/arch/x86/kernel/apic/apic_noop.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/apic_noop.c
+++ linux-2.6.git/arch/x86/kernel/apic/apic_noop.c
@@ -162,7 +162,12 @@ struct apic apic_noop = {
 
 	.cpu_to_logical_apicid		= noop_cpu_to_logical_apicid,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
+
+#ifdef CONFIG_X86_32
 	.apicid_to_cpu_present		= default_apicid_to_cpu_present,
+#else
+	.apicid_to_cpu_present		= NULL,
+#endif
 
 	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
