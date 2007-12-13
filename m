Return-Path: <linux-kernel-owner+w=401wt.eu-S1758809AbXLMNu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758809AbXLMNu3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 08:50:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753977AbXLMNuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 08:50:16 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33847
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752505AbXLMNuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 08:50:14 -0500
Date: Thu, 13 Dec 2007 05:50:13 -0800 (PST)
Message-Id: <20071213.055013.83963139.davem@davemloft.net>
To: jarkao2@gmail.com
Cc: auke-jan.h.kok@intel.com, gallatin@myri.com, joonwpark81@gmail.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       shemminger@linux-foundation.org, jesse.brandeburg@intel.com
Subject: Re: [RFC] net: napi fix
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071213134953.GA3806@ff.dom.local>
References: <47602B77.2090202@intel.com>
	<20071213134953.GA3806@ff.dom.local>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarek Poplawski <jarkao2@gmail.com>
Date: Thu, 13 Dec 2007 14:49:53 +0100

> As a matter of fact, since it's "unlikely()" in net_rx_action() anyway,
> I wonder what is the main reason or gain of leaving such a tricky
> exception, instead of letting drivers to always decide which is the
> best moment for napi_complete()? (Or maybe even, in such a case, they
> should call some function with this list_move_tail() if it's so
> useful?)

It is the only sane way to synchronize the list manipulations.

There has to be a way for ->poll() to tell net_rx_action() two things:

1) How much work was completed, so we can adjust 'budget'
2) Was the NAPI quota exhausted?  So that we know that
   net_rx_action() still "owns" the polling context and
   thus can do the list manipulation safely.

And these both need to be encoded into one single return value, thus
the adopted convention that "work == weight" means that the device has
not done a NAPI complete.
