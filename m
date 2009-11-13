Return-Path: <linux-kernel-owner+w=401wt.eu-S1755060AbZKMNtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060AbZKMNtb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 08:49:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbZKMNt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 08:49:29 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:60853 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620AbZKMNt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 08:49:28 -0500
Date: Fri, 13 Nov 2009 06:49:33 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: "Meng, Chen" <Chen.Meng@windriver.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       "Wallin, Anders" <Anders.Wallin@windriver.com>,
       "Feng, Xiaobing" <Xiaobing.Feng@windriver.com>,
       "Li, Li" <Li.Li@windriver.com>, giancarlo.asnaghi@st.com
Subject: Re: [PATCH] GPIO driver for ST Microelectronics ConneXt
	(STA2X11/STA2X10), PCIe I/O Hub
Message-ID: <20091113134933.GH16033@parisc-linux.org>
References: <D87B22B1FE8C0F479CA9BEAD6C25AAE8043659AF@ism-mail03.corp.ad.wrs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D87B22B1FE8C0F479CA9BEAD6C25AAE8043659AF@ism-mail03.corp.ad.wrs.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 13, 2009 at 01:23:26PM +0100, Meng, Chen wrote:
>     This patch is a GPIO driver for  ST Microelectronics ConneXt
> (STA2X11/STA2X10), PCIe I/O Hub.
>     It's derived from pl061.c and compatible with GPIOLIB.

You really need to run this driver through scripts/Lindent ...

> +#define ppwrite(dat, base, adr) writel((dat), (base) + (adr))
> +#define ppread(base, adr)  readl((base) + (adr))

Why not just use readl and writel directly?

> +int pl061_pci_gpio_request(struct gpio_chip *gpio, unsigned nr) {
> + struct pl061_pci *pp = container_of(gpio, struct pl061_pci, gpio);
> + u32 flag = 1 << (nr % PINS_PER_CHIP);
> + u32 *mutex = &pp->mutex[nr / PINS_PER_CHIP];
> +
> + if (nr >= gpio->ngpio)
> +  return -EINVAL;
> + if ((*mutex) & flag)
> +  return -EBUSY;
> +
> + *mutex |=  flag;
> +
> + return 0;
> +}

gpiolib calls chip->request without a lock held, so you need some locking
to protect pp->mutex.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
