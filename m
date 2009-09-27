Return-Path: <linux-kernel-owner+w=401wt.eu-S1752692AbZI0VCM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692AbZI0VCM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 17:02:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751038AbZI0VCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 17:02:11 -0400
Received: from mail.gmx.net ([213.165.64.20]:47236 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750955AbZI0VCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 17:02:10 -0400
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX1/7FB4ew+f7UPGAkRPVSLXQgCt9SJ92db8qBjd2Zu
	dBXeGFBp95tu3N
Message-ID: <4ABFD2D3.5050606@gmx.de>
Date: Sun, 27 Sep 2009 23:02:11 +0200
From: Helge Deller <deller@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Tim Abbott <tabbott@ksplice.com>
CC: linux-parisc@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH v2 0/2] Linker script cleanup patches for parisc
References: <1253306078-7066-1-git-send-email-tabbott@ksplice.com>
In-Reply-To: <1253306078-7066-1-git-send-email-tabbott@ksplice.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2009 10:34 PM, Tim Abbott wrote:
> This is an updated version of the patch series I sent on September 6
> cleaning up the parisc architecture's linker scripts.  [....]
> 	-Tim Abbott
>
> Tim Abbott (2):
>    parisc: Clean up linker script using new linker script macros.
>    parisc: Remove useless altinstructions code copied from x86.
>
>   arch/parisc/kernel/vmlinux.lds.S |  104 ++------------------------------------
>   1 files changed, 4 insertions(+), 100 deletions(-)
  
Tim, thanks for your work!

Sadly it broke the parisc build in two places:
a) THREAD_SIZE can't be used in the vmlinux.lds.S file
b) It generates linker errors like "local symbol 0: discarded in section `.exit.text' from kernel/built-in.o".

Attached patch below fixes both issues. Tested with 32- and 64-bit parisc kernel.

Helge

--------
parisc: Fix linker script breakage.

Signed-off-by: Helge Deller <deller@gmx.de>

diff --git a/arch/parisc/kernel/asm-offsets.c b/arch/parisc/kernel/asm-offsets.c
index 699cf8e..7e76f03 100644
--- a/arch/parisc/kernel/asm-offsets.c
+++ b/arch/parisc/kernel/asm-offsets.c
@@ -287,6 +287,8 @@ int main(void)
  	DEFINE(ASM_PFN_PTE_SHIFT, PFN_PTE_SHIFT);
  	DEFINE(ASM_PT_INITIAL, PT_INITIAL);
  	BLANK();
+	DEFINE(ASM_THREAD_SIZE, THREAD_SIZE);
+	BLANK();
  	DEFINE(EXCDATA_IP, offsetof(struct exception_data, fault_ip));
  	DEFINE(EXCDATA_SPACE, offsetof(struct exception_data, fault_space));
  	DEFINE(EXCDATA_ADDR, offsetof(struct exception_data, fault_addr));
diff --git a/arch/parisc/kernel/vmlinux.lds.S b/arch/parisc/kernel/vmlinux.lds.S
index 775be27..8347dfc 100644
--- a/arch/parisc/kernel/vmlinux.lds.S
+++ b/arch/parisc/kernel/vmlinux.lds.S
@@ -89,7 +89,7 @@ SECTIONS
  	}
  
  	/* Data */
-	RW_DATA_SECTION(L1_CACHE_BYTES, PAGE_SIZE, THREAD_SIZE)
+	RW_DATA_SECTION(L1_CACHE_BYTES, PAGE_SIZE, ASM_THREAD_SIZE)
  
  	/* PA-RISC locks requires 16-byte alignment */
  	. = ALIGN(16);
@@ -135,6 +135,16 @@ SECTIONS
  	INIT_TEXT_SECTION(16384)
  	INIT_DATA_SECTION(16)
  
+	/* we have to discard exit text and such at runtime, not link time */
+	.exit.text :
+	{
+		EXIT_TEXT
+	}
+	.exit.data :
+	{
+		EXIT_DATA
+	}
+
  	PERCPU(PAGE_SIZE)
  	. = ALIGN(PAGE_SIZE);
  	__init_end = .;
