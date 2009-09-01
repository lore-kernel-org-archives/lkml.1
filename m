Return-Path: <linux-kernel-owner+w=401wt.eu-S1755294AbZIAW3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294AbZIAW3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 18:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755241AbZIAW3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 18:29:17 -0400
Received: from outbound-mail-108.bluehost.com ([69.89.22.8]:37469 "HELO
	outbound-mail-108.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752504AbZIAW3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 18:29:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=ovS2MdQI9nehM5hVnpNBL2Ylzr2E3FRAgWjYUmVAjSl30G7phDaY5kBYvMmUPbFvLqrx+s2Dv7nBw+ojL+0KmWH7yfP27Wuwe3EjfJkvGrdJMljSTFjGxvU3xDqmUTdz;
Date: Tue, 1 Sep 2009 15:28:57 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org,
       Jesse Brandeburg <jesse.brandeburg@gmail.com>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] x86/PCI: initialize PCI bus node numbers early
Message-ID: <20090901152857.7f809937@jbarnes-g45>
In-Reply-To: <20090901135358.GA31282@elte.hu>
References: <20090710104419.0032be7b@jbarnes-g45>
	<20090901135358.GA31282@elte.hu>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Sep 2009 15:53:58 +0200
Ingo Molnar <mingo@elte.hu> wrote:
>   acccaba: x86/PCI: initialize PCI bus node numbers early
> 
> caused a boot crash in -tip testing:
> 
> calling  amd_init+0x0/0x16 @ 1
> pata_amd 0000:00:06.0: version 0.4.1
> pata_amd 0000:00:06.0: setting latency timer to 64
> BUG: unable to handle kernel NULL pointer dereference at 00000e44

The 32 bit part looked a bit off, (unsigned char)-1 == 255.  Could
definitely cause issues ("any node" is supposed to be a real -1).

Can you give this patch a try?  (Note this code is a copy & paste of
the original AMD code, it could stand some cleanup.)

Thanks,
Jesse

diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index eb6eb61..ffcb516 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -640,7 +640,7 @@ int get_mp_bus_to_node(int busnum)
 
 #else /* CONFIG_X86_32 */
 
-static unsigned char mp_bus_to_node[BUS_NR] = {
+static int mp_bus_to_node[BUS_NR] = {
 	[0 ... BUS_NR - 1] = -1
 };
 
