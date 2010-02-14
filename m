Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab0BNUlk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 15:41:40 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:53316 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab0BNUli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 15:41:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GPZGSGmXnLrrvK27yHQS4/ssOPLcooeLAx9yJFZbelV6tmuzYYkNZKnSvINqTU++iu
         rYCShEIvVd1dMJ26zplp+66G3ZKM1fkeKGJPAraiqIKFFO5u75KOeifKRLCOpxnqaj9E
         hBQBgfe6eu+Rk7CNVy978PO/yEaQsMhKmgOPM=
Date: Sun, 14 Feb 2010 21:41:32 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Michael Stefaniuc <mstefani@redhat.com>
Cc: prasad@linux.vnet.ibm.com, Alan Stern <stern@rowland.harvard.edu>,
       linux-kernel@vger.kernel.org, Maneesh Soni <maneesh@linux.vnet.ibm.com>,
       Alexandre Julliard <julliard@winehq.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: Regression in ptrace (Wine) starting with 2.6.33-rc1
Message-ID: <20100214204130.GD5479@nowhere>
References: <4B743149.4000707@redhat.com> <20100211182224.GC4915@nowhere> <4B745F5C.5050001@redhat.com> <20100213173323.GB3778@in.ibm.com> <4B7719AC.6040901@redhat.com> <20100214171535.GA5065@nowhere> <4B785952.8020706@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B785952.8020706@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 14, 2010 at 09:13:06PM +0100, Michael Stefaniuc wrote:
> Although Wine will map address 0x0 for DOS programs that isn't the  
> reason for those tests. Wine has to support games that come with  
> pointless copy protection schemes that employ that technique.


Ah, which kind of protection?



> Cool, thanks!
> Any chance to get that fix into 2.6.33?


Yeah.

Could you please test the following patch on top of
2.6.33-rc9 ?
I'm trying to build wine but it fails because my libx11 is
incorrect for the linking (probably because I don't have a x86-32
version of libx11.so):

diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index 05d5fec..bb6006e 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -212,25 +212,6 @@ static int arch_check_va_in_kernelspace(unsigned long va, u8 hbp_len)
 	return (va >= TASK_SIZE) && ((va + len - 1) >= TASK_SIZE);
 }
 
-/*
- * Store a breakpoint's encoded address, length, and type.
- */
-static int arch_store_info(struct perf_event *bp)
-{
-	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
-	/*
-	 * For kernel-addresses, either the address or symbol name can be
-	 * specified.
-	 */
-	if (info->name)
-		info->address = (unsigned long)
-				kallsyms_lookup_name(info->name);
-	if (info->address)
-		return 0;
-
-	return -EINVAL;
-}
-
 int arch_bp_generic_fields(int x86_len, int x86_type,
 			   int *gen_len, int *gen_type)
 {
@@ -362,10 +343,13 @@ int arch_validate_hwbkpt_settings(struct perf_event *bp,
 		return ret;
 	}
 
-	ret = arch_store_info(bp);
-
-	if (ret < 0)
-		return ret;
+	/*
+	 * For kernel-addresses, either the address or symbol name can be
+	 * specified.
+	 */
+	if (info->name)
+		info->address = (unsigned long)
+				kallsyms_lookup_name(info->name);
 	/*
 	 * Check that the low-order bits of the address are appropriate
 	 * for the alignment implied by len.



> I cannot test that as the corresponding test is directly affected by  
> this ABI change.


Sure, let's fix the first problem to begin.

Thanks!

