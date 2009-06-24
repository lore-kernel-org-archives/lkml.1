Return-Path: <linux-kernel-owner+w=401wt.eu-S1762202AbZFXUFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762202AbZFXUFG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 16:05:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762280AbZFXUEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 16:04:42 -0400
Received: from outbound-mail-142.bluehost.com ([67.222.38.32]:38091 "HELO
	outbound-mail-142.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1762319AbZFXUEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 16:04:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=WeMnuFmWLXus9c2AAayhOJSaTWtrXOCiJ40w2vovH1U7ZQQc0yHXOgLov92r+xUe/c5zZYDASmvL/dBES7uCQufbW4B49EBrsDdgbgrk3/l6xr0mYLEzWhrITXM/ZGRs;
Date: Wed, 24 Jun 2009 13:04:41 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Justin Mattock <justinmattock@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>
Subject: Re: pci 0000:01:00.0: BAR 6: no parent found for of device
 [0xfffe0000-0xffffffff]
Message-ID: <20090624130441.1c25c40e@jbarnes-g45>
In-Reply-To: <20090624195030.GS19977@parisc-linux.org>
References: <dd18b0c30906241027u152274b1kd4c854ada4de33dd@mail.gmail.com>
	<200906242130.07583.rjw@sisk.pl>
	<20090624195030.GS19977@parisc-linux.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jun 2009 13:50:30 -0600
Matthew Wilcox <matthew@wil.cx> wrote:

> On Wed, Jun 24, 2009 at 09:30:07PM +0200, Rafael J. Wysocki wrote:
> > (Adding CC to linux-pci)
> 
> Thanks Rafael.
> 
> > On Wednesday 24 June 2009, Justin Mattock wrote:
> > > (just pulled the latest git)
> > > And am seeing this:
> > 
> > Where pci 0000:01:00.0 and 0000:02:00.0 are what?
> > 
> > > [    0.696001] pci 0000:01:00.0: BAR 6: no parent found for of
> > > device [0xfffe0000-0xffffffff]
> 
> So the message is coming from pci_claim_resource, and
> if you bother to bisect, you'll track it back to my commit
> a76117dfd687ec4be0a9a05214f3009cc5f73a42 .  What's going on here,
> since this is BAR 6, is we have a ROM which has been mapped high, and
> then not unmapped.  The BAR doesn't fit in the parent's window, so
> the code is rightly declining to allocate the BAR.
> 
> Before my patch, we silently didn't allocate the BARs.  Now we print
> a message.  I wonder what to do ... we could silence this warning in
> pci_claim_resource (patch below).  Or we could declare this to be a
> bug, and fix it by disabling the ROM BAR (by clearing bit 0).
> 
> I'm agnostic ... anyone have any preferences?

Well, given that sometimes the ROM is important, it seems like an
error.  Really we should be smarter about re-allocating things as
necessary...

-- 
Jesse Barnes, Intel Open Source Technology Center
