Return-Path: <linux-kernel-owner+w=401wt.eu-S1762768AbYHERjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762768AbYHERjO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 13:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762494AbYHERiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 13:38:54 -0400
Received: from outbound-mail-101.bluehost.com ([69.89.22.11]:60750 "HELO
	outbound-mail-101.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1762477AbYHERiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 13:38:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=OSvZ3zWoW/dfaR4NpKtX6m4Ao+ukkLJm1d1IAmoFhR0CxF8ji3ADrISZWYPgYiOpuY026oiQJ7z6IQN3fohjC1mZLN9PRU+cqYYAyauLtnaupUw3xWlRAniBliiKv4x3;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH 2/2] fusion:  Implement generic interrupt misroute handling
Date: Tue, 5 Aug 2008 10:38:38 -0700
User-Agent: KMail/1.9.9
Cc: David Vrabel <david.vrabel@csr.com>, "Moore, Eric" <Eric.Moore@lsi.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "Prakash, Sathya" <Sathya.Prakash@lsi.com>
References: <1217786709.4179.27.camel@localhost.localdomain> <48970A4D.2090309@csr.com> <1217954187.9923.15.camel@localhost.localdomain>
In-Reply-To: <1217954187.9923.15.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808051038.39275.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 05, 2008 9:36 am James Bottomley wrote:
> On Mon, 2008-08-04 at 14:55 +0100, David Vrabel wrote:
> > Moore, Eric wrote:
> > > Thanks, I will try this out.   However I thought I saw lost
> > > interrupts occurring randomly, meaning it was not necessarily the
> > > first config page access.  I'm back in the office on 8/11, I will
> > > test it out then and provide feedback.
> >
> > Is this using MSI on a device without per-vector mask bits?  If so, then
> > this patch may help.
> >
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit
> >;h=ce6fce4295ba727b36fdc73040e444bd1aae64cd
>
> We don't really know what the problem is.  MSI interrupts get lost on
> older motherboards (the ones most likely to contain a 1030).  Why is
> anybody's guess although the clever money is on the motherboard bridge
> having issues.

David just got us to fix an MSI masking bug recently, which could be related.

The issue is that the PCI & interrupt handling code was disabling MSI during 
interrupt handling, which could end up causing missed interrupts.  When MSI 
is disabled, devices can still generate interrupts, but they'll go out the 
interrupt line instead, so unless your IRQ handler is also registered with 
that IRQ number, you'll probably lose them.

As of the last PCI upstream merge, we work around this issue by never masking 
MSI interrupts unless the device supports the MSI mask bit (as opposed to 
just the big hammer enable/disable flag).

Jesse


