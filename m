Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006Ab0CIUpP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 15:45:15 -0500
Received: from mail.digidescorp.com ([66.244.163.200]:41468 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100Ab0CIUpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 15:45:11 -0500
X-Spam-Processed: digidescorp.com, Tue, 09 Mar 2010 14:45:10 -0600
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=1684ea2dd6=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
Subject: tcp_recvmesg hang under NET_DMA
From: "Steven J. Magnani" <steve@digidescorp.com>
Reply-To: steve@digidescorp.com
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain
Organization: Digital Design Corporation
Date: Tue, 09 Mar 2010 14:44:59 -0600
Message-Id: <1268167499.2985.32.camel@iscandar.digidescorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've run into a case where using NET_DMA seems to cause a PUT to a
modified ftpd to hang. AFAICT this is because the NET_DMA design queues
up lots of memcpy operations, but doesn't issue or wait for them (and
thus free the associated skbs) until it is time for tcp_recvmesg() to
return. In a case where userland requests a large read (as is the case
in my modified ftpd), packet transfer can grind to a halt because so
many packets are buffered up and there is no event that causes them to
be freed.

I can submit a patch that would issue pending memcpys and clean up
completed ones around tcp_recvmsg's call to sk_wait_data(), but first I
wanted to understand the design better. Were there specific reasons for
deferring the async operations so long?

Thanks,
------------------------------------------------------------------------
 Steven J. Magnani               "I claim this network for MARS!
 www.digidescorp.com              Earthling, return my space modulator!"

 #include <standard.disclaimer>


