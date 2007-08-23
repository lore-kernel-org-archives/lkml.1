Return-Path: <linux-kernel-owner+w=401wt.eu-S932310AbXHWWDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310AbXHWWDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 18:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761048AbXHWWDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 18:03:22 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:2983 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbXHWWDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 18:03:21 -0400
Message-ID: <46CE041B.8030403@chelsio.com>
Date: Thu, 23 Aug 2007 15:03:07 -0700
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: Jeff Garzik <jeff@garzik.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Steve Wise <swise@opengridcomputing.com>
Subject: Re: [PATCH 0/3] cxgb3 driver update
References: <46CD2AA8.9070507@chelsio.com> <20070823070216.GI21089@ftp.linux.org.uk>
In-Reply-To: <20070823070216.GI21089@ftp.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Aug 2007 22:01:47.0842 (UTC) FILETIME=[3381D220:01C7E5D1]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

> Speaking of cxgb3, could you explain what the hell is
> static int do_term(struct t3cdev *dev, struct sk_buff *skb)
> {
>         unsigned int hwtid = ntohl(skb->priority) >> 8 & 0xfffff;
> doing?  AFAIK, skb->priority is not net-endian...
>

the RDMA connection id is saved in the skb's priority field for TERM 
messages
because it is not in the CPL message that comes up from the hardware.
Yet the RDMA driver needs it, so sge.c::process_responses() overloads
the skb's priority and csum with these values.


>
> Another odd place is
> int t3_seeprom_write(struct adapter *adapter, u32 addr, u32 data)
> {  
>         u16 val;
>         int attempts = EEPROM_MAX_POLL;
>         unsigned int base = adapter->params.pci.vpd_cap_addr;
>
>         if ((addr >= EEPROMSIZE && addr != EEPROM_STAT_ADDR) || (addr 
> & 3))  
>                 return -EINVAL;
>
>         pci_write_config_dword(adapter->pdev, base + PCI_VPD_DATA,
>                                cpu_to_le32(data));
> with callers like
> int t3_seeprom_wp(struct adapter *adapter, int enable)
> {
>         return t3_seeprom_write(adapter, EEPROM_STAT_ADDR, enable ? 
> 0xc : 0);
>
> IOW, you really get little-endian values passed to 
> pci_write_config_dword()
> and it expects a host-endian as the last argument...
>

It looks like a bug. Thanks for spotting this.

Cheers,
Divy

