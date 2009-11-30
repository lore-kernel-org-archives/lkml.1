Return-Path: <linux-kernel-owner+w=401wt.eu-S1753108AbZK3Jsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108AbZK3Jsl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 04:48:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbZK3Jsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 04:48:40 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33770 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005AbZK3Jsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 04:48:40 -0500
Date: Mon, 30 Nov 2009 09:48:13 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Marc Zyngier <maz@misterjones.org>
Cc: Eric Miao <eric.y.miao@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the pcmcia tree with the pxa tree
Message-ID: <20091130094813.GC1638@n2100.arm.linux.org.uk>
References: <20091130131627.8ccc6033.sfr@canb.auug.org.au> <f17812d70911291917y2aeebbberbf31775491f0df4f@mail.gmail.com> <20091130091007.7a5fd554@hina.wild-wind.fr.eu.org> <f17812d70911300016q1e729569k8c72deb704e3a658@mail.gmail.com> <20091130102444.4ebc0a45@life-in-the-fast-lane>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091130102444.4ebc0a45@life-in-the-fast-lane>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 10:24:44AM +0100, Marc Zyngier wrote:
> Sounds good. I'll post rebased patches as soon as PCMCIA hits Linus'
> tree.

What would be a better idea is to rework the driver once my changes have
hit.  If you need to pass additional data around, you can do it like this:

struct my_socket {
	struct soc_pcmcia_socket skt;
	...
};

#define to_my_socket(s) container_of(s, struct my_socket, skt)

static struct pcmcia_low_level my_ops = {
};

static int my_probe(struct platform_device *dev)
{
	struct my_socket *skts;

	pxa2xx_drv_pcmcia_ops(&my_ops);

	skts = kzalloc(sizeof(*skts) * nr, GFP_KERNEL);
	if (!skts)
		...

	for (i = 0; i < nr; i++) {
		skts[i].skt.nr = i;
		skts[i].skt.ops = &my_ops;
		skts[i].skt.socket.owner = THIS_MODULE;
		skts[i].skt.socket.parent = &dev->dev;
		skts[i].skt.socket.pci_irq = the_socket_irq;
		ret = pxa2xx_drv_pcmcia_add_one(&skts[i].skt);
		if (ret)
			goto free_registered_sockets_and_return_ret;
	}
}
