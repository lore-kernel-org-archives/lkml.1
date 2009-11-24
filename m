Return-Path: <linux-kernel-owner+w=401wt.eu-S934076AbZKXVh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934076AbZKXVh2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 16:37:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933480AbZKXVh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 16:37:27 -0500
Received: from isilmar.linta.de ([213.133.102.198]:41557 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932945AbZKXVh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 16:37:27 -0500
Date: Tue, 24 Nov 2009 22:37:23 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: x86@kernel.org
Cc: Komuro <komurojun-mbn@nifty.com>, linux-pcmcia@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: ioports 0x100-0x3af and iomem 0xd000-0xdffff,
	0xa0000000-0xa0ffffff -- safe to use on x86 for pcmcia?
Message-ID: <20091124213723.GA22689@comet.dominikbrodowski.net>
Mail-Followup-To: x86@kernel.org, Komuro <komurojun-mbn@nifty.com>,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hej!

One of the most problematic issues with the whole 16-bit PCMCIA subsystem on
the x86 architecture is the following: cards request iomem or ioport
resources, but the PCMCIA subsystem does and can not know reliably at what
addresses iomem and ioport resources may be used, without interfering with
any third hardware.

Currently, we utilize two approaches to correctly "guess" which iomem and
ioport resource areas are safe to use[*]:

- If the PCMCIA bridge resides behind a PCI-PCI bridge or a PCI root bridge
  with specific memory or I/O windows, these resoruces -- if not registered
  otherwise -- are made available to PCMCIA devices. This works great on
  modern hardware, and hasn't caused us any major hassles since its
  introduction in 2.6.13 or so.

- Userspace (pcmcia-cs or pcmciautils) parses /etc/pcmcia/config.opts and
  registers a couple of memory and I/O resources.

  This latter configuration file most often contains 
	include port 0x100-0x3af
	include memory 0xc0000-0xfffff
	include memory 0xa0000000-0xa0ffffff

And so Komuro (CCed) suggested to add these default resource entries to the
kernel, so that it can later use parts of these resource areas to enable
PCMCIA devices without userspace interaction.

Do you think it would be safe to enable these areas by (kernel) default on
x86? Of course, other entries in /proc/io{mem,ports} would be honoured, there
would be a boot option to disable this feature, and some tests are run on the
iomem and ioport resource areas.

Best,
	Dominik

[*] In addition, there are some tests which are run on iomem and ioport
resources before marking them as available to PCMCIA devices, but let's
ignore this aspect for the moment.
