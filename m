Return-Path: <linux-kernel-owner+w=401wt.eu-S1759321AbYHDXFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759321AbYHDXFE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 19:05:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753467AbYHDXEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 19:04:54 -0400
Received: from outbound-mail-22.bluehost.com ([69.89.21.17]:52375 "HELO
	outbound-mail-22.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752555AbYHDXEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 19:04:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=SqYtye0y3wQ0JnbhSvTneC4piiXW3KY/6mtkdPlDQpt+y+KeSlTukR13eGlK8beftrkywlsHGjX6q/nFWZhWiDn22jZX88n7d6PU8H0nUg2+NibQq1l/mAdiFBF0RmHn;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: BUG: scheduling while atomic: ip/23212/0x00000102
Date: Mon, 4 Aug 2008 16:04:46 -0700
User-Agent: KMail/1.9.9
Cc: David Miller <davem@davemloft.net>, arekm@maven.pl,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <200808041845.10893.arekm@maven.pl> <20080804.143541.96067332.davem@davemloft.net> <200808050010.45615.rjw@sisk.pl>
In-Reply-To: <200808050010.45615.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808041604.47219.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 04, 2008 3:10 pm Rafael J. Wysocki wrote:
> > -	pci_read_config_word(tp->pdev,
> > -			     pm + PCI_PM_CTRL,
> > -			     &power_control);
> > -	power_control |= PCI_PM_CTRL_PME_STATUS;
> > -	power_control &= ~(PCI_PM_CTRL_STATE_MASK);
> >  	switch (state) {
> >  	case PCI_D0:
> > -		power_control |= 0;
> > -		pci_write_config_word(tp->pdev,
> > -				      pm + PCI_PM_CTRL,
> > -				      power_control);
> > -		udelay(100);	/* Delay after power state change */
> > +		pci_enable_wake(tp->pdev, state, false);
> > +		pci_set_power_state(tp->pdev, PCI_D0);
>
> Still, I don't think drivers should access the standard PCI PM registers
> directly, so perhaps there should be a version of pci_set_power_state()
> using udelay() instead of msleep() or we can just replace the msleep()
> in pci_set_power_state() with udelay()?

I think we should get rid of the open coded PCI PM state management, since 
otherwise platform related bugs like the Intel PCIe PM quirk that sets 
pci_pm_d3_delay to 120ms would have to be duplicated around the tree.

That said, waiting for 120ms with a busy wait seems a bit absurd if we can 
avoid it.  Either we need to find a way to make drivers only change states 
(which can be very slow) in non-atomic context or we'll need to add a busy 
wait variant of the power state call...

Jesse
