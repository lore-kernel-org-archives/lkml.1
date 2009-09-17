Return-Path: <linux-kernel-owner+w=401wt.eu-S1755325AbZIQPWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325AbZIQPWe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 11:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754116AbZIQPWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 11:22:30 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:46479 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787AbZIQPW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 11:22:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uIxYDp6qkh9TaGb56WAfEvrN1INY/H+lYoohyRBnDdT6PCikzjnxPB9LyXfu9tere5
         nraq8Bid/w5My1AZtZszeDlMbQE5pgXVyFR9PAA0RPSSNxS8+701yfAptO9iWuT2MuMR
         ONXf6TEP41v1mfW8k6w08lla4MFNvsmrMHHd8=
Date: Thu, 17 Sep 2009 19:22:27 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Tim Abbott <tabbott@ksplice.com>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Anders Kaseorg <andersk@ksplice.com>
Subject: Re: [PATCH v3 1/5] x86: fix fragile computation of vsyscall address
Message-ID: <20090917152227.GA8817@lenovo>
References: <1253133870-25140-1-git-send-email-tabbott@ksplice.com> <1253133870-25140-2-git-send-email-tabbott@ksplice.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253133870-25140-2-git-send-email-tabbott@ksplice.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Tim Abbott - Wed, Sep 16, 2009 at 04:44:26PM -0400]
|
| From: Anders Kaseorg <andersk@ksplice.com>
| 
| Previously, the address of the vsyscall page (VSYSCALL_PHYS_ADDR,
| VSYSCALL_VIRT_ADDR) was computed by arithmetic on the address of the
| last section.  This leads to bugs when new sections are inserted, such
| as the one fixed by commit d312ceda567ab91acd756cde95ac5fbc6b40ed40.
| Let's compute it from the current address instead.
| 
| Signed-off-by: Anders Kaseorg <andersk@ksplice.com>
| ---
|  arch/x86/kernel/vmlinux.lds.S |   19 +++++++------------
|  1 files changed, 7 insertions(+), 12 deletions(-)
| 
| diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
| index 0ccb57d..b96ca47 100644
| --- a/arch/x86/kernel/vmlinux.lds.S
| +++ b/arch/x86/kernel/vmlinux.lds.S
| @@ -135,24 +135,21 @@ SECTIONS
|  #ifdef CONFIG_X86_64
|  
|  #define VSYSCALL_ADDR (-10*1024*1024)
| -#define VSYSCALL_PHYS_ADDR ((LOADADDR(.data) + SIZEOF(.data) + \
| -                            PAGE_SIZE - 1) & ~(PAGE_SIZE - 1))
| -#define VSYSCALL_VIRT_ADDR ((ADDR(.data) + SIZEOF(.data) + \
| -                            PAGE_SIZE - 1) & ~(PAGE_SIZE - 1))
|  
| -#define VLOAD_OFFSET (VSYSCALL_ADDR - VSYSCALL_PHYS_ADDR)
| +#define VLOAD_OFFSET (VSYSCALL_ADDR - __vsyscall_0 + LOAD_OFFSET)
|  #define VLOAD(x) (ADDR(x) - VLOAD_OFFSET)
|  
| -#define VVIRT_OFFSET (VSYSCALL_ADDR - VSYSCALL_VIRT_ADDR)
| +#define VVIRT_OFFSET (VSYSCALL_ADDR - __vsyscall_0)
|  #define VVIRT(x) (ADDR(x) - VVIRT_OFFSET)
|  
| +	. = ALIGN(4096);

Hi Tim, it seems there should be PAGE_SIZE, or I miss something?
(great work btw!)

| +	__vsyscall_0 = .;
| +
...

	-- Cyrill
