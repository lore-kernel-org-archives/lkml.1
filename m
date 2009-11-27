Return-Path: <linux-kernel-owner+w=401wt.eu-S1751484AbZK0HyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484AbZK0HyJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 02:54:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751003AbZK0HyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 02:54:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:39659 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbZK0HyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 02:54:07 -0500
Message-ID: <4B0F854C.4010902@kernel.org>
Date: Thu, 26 Nov 2009 23:52:44 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: [PATCH 1/2] pci: release that leaf bridge' resource that is not
 big -v11
References: <4ADEB601.8020200@kernel.org>	<4AE80170.6030402@jp.fujitsu.com>	<4AE88305.8020207@kernel.org>	<m1ljivibrt.fsf@fess.ebiederm.org>	<4AE899A0.3020006@kernel.org>	<4AE95247.8080401@jp.fujitsu.com>	<4AE952B9.1010603@kernel.org>	<4AE9588E.90708@jp.fujitsu.com>	<4AE9657F.7010302@kernel.org>	<4AE965D9.9040702@kernel.org> <20091104093044.17ab628a@jbarnes-piketon> <4AF1CD79.4010602@kernel.org> <4AF22CF1.1020508@kernel.org> <4AF22D26.4070500@kernel.org> <4AF508F0.9060105@kernel.org> <4AF91F54.10507@jp.fujitsu.com> <4AF936DB.1030309@kernel.org> <4AFCF7D8.1090207@jp.fujitsu.com> <4AFCFC0D.4030002@kernel.org> <4AFD19DA.7010602@jp.fujitsu.com> <4AFE6F39.5080505@kernel.org> <4B0B321E.4010103@jp.fujitsu.com> <4B0B335E.1070809@kernel.org> <4B0B3C13.9030502@jp.fujit! su.com> <4B0C69AD.3030106@kernel. org> <4B0D13EB.9010403@jp.fujitsu.com> <4B0D6CFE.4070804@kerne! l .org> <4B0E2388.50302@jp.fujitsu.com> <A2C249D4-FC31-40D9-ACEA-807C336F8514@kernel.org> <4B0F7BC6.90105@jp.fujitsu.com>
In-Reply-To: <4B0F7BC6.90105@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
> 
> Bad news...
> 
> My system doesn't boot (hangup) with your latest set of patches.
> Fusion MPT SAS driver initialization failed on some devices.
> Please see below
> 
> ...
> Fusion MPT SAS Host driver 3.04.12
> mptsas 0000:09:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
> mptsas 0000:09:00.0: BAR 1: can't reserve [mem 0x00510000-0x00513fff 64bit]
> mptbase: ioc0: ERROR - pci_request_selected_regions() with MEM failed
> mptsas 0000:0a:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
> mptsas 0000:0a:00.0: BAR 1: can't reserve [mem 0x00610000-0x00613fff 64bit]
> mptbase: ioc1: ERROR - pci_request_selected_regions() with MEM failed
> ...
> 
> 
> This problem disappear when I revert the patch 6/9, and my system
> can boot. But I found igb driver initialization failed on some
> devices even in this case. Please see below
> 
> ...
> igb 0000:08:00.0: BAR 0: can't reserve [mem 0x00100000-0x0011ffff]
> igb 0000:08:00.0: PCI INT A disabled
> igb: probe of 0000:08:00.0 failed with error -16
> igb 0000:08:00.1: PCI INT B -> GSI 18 (level, low) -> IRQ 18
> igb 0000:08:00.1: BAR 0: can't reserve [mem 0x00140000-0x0015ffff]
> igb 0000:08:00.1: PCI INT B disabled
> igb: probe of 0000:08:00.1 failed with error -16
> ...

that looks werid, without patch 6/9 should only have pci bridge res shrink problem with your last test?

maybe we need keep that feature default to be disabled.

please try

---
 drivers/pci/setup-bus.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-2.6/drivers/pci/setup-bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
@@ -918,8 +918,7 @@ static void pci_bus_dump_resources(struc
  * second try will clear small leaf bridge res
  * third try will clear related bridge: some aggressive
  */
-/* assume we only have 4 level bridges, so only try 5 times */
-int pci_try_num = 5;
+int pci_try_num = 1;
 void __init
 pci_assign_unassigned_resources(void)
 {
