Return-Path: <linux-kernel-owner+w=401wt.eu-S1757595AbYGPHqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595AbYGPHqW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 03:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753497AbYGPHqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 03:46:15 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:17883 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991AbYGPHqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 03:46:14 -0400
Date: Wed, 16 Jul 2008 09:46:02 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "David Hubbard" <david.c.hubbard@gmail.com>
Cc: "Hans de Goede" <j.w.r.degoede@hhs.nl>, linuxppc-dev@ozlabs.org,
       "Samuel Ortiz" <samuel@sortiz.org>, linux-kernel@vger.kernel.org,
       "Milton Miller" <miltonm@bga.com>, lm-sensors@lm-sensors.org
Subject: Re: [RFC] (almost) booting allyesconfig -- please don't poke
 super-io without request_region
Message-ID: <20080716094602.4379e0ff@hyperion.delvare>
In-Reply-To: <4dfa50520807150831i519a3a43n635ab7e58d35ba5e@mail.gmail.com>
References: <for-27-patch1-0@bga.com>
	<4879A144.8060203@hhs.nl>
	<4dfa50520807131411ied883cgcb20eb6bd94f761@mail.gmail.com>
	<487A7211.7030309@hhs.nl>
	<4dfa50520807131426t4013142cp1fcd49e078a79c1f@mail.gmail.com>
	<20080714095914.0644ac5d@hyperion.delvare>
	<88f5162604470179b3c6ebfe729a46f5@bga.com>
	<487B8D2C.1090208@hhs.nl>
	<4dfa50520807141055l532caaaai700255936600e5ae@mail.gmail.com>
	<20080715103613.4fbbf01f@hyperion.delvare>
	<4dfa50520807150831i519a3a43n635ab7e58d35ba5e@mail.gmail.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Tue, 15 Jul 2008 09:31:29 -0600, David Hubbard wrote:
> On Tue, Jul 15, 2008 at 2:36 AM, Jean Delvare <khali@linux-fr.org> wrote:
> > I always assumed that there was no way to know in advance if a
> > Super-I/O (LPC) chip was present or not, let alone the exact model of
> > the chip. The I/O addresses are decoded by the Super-I/O chip itself,
> > and in general it has no relation to PCI. And I've never seen ports
> > 0x2e/0x2f nor 0x4e/0x4f listed in /proc/ioports.
> >
> > But of course if there is a way to know, we should use it. Avoiding
> > random access to I/O ports, even if they are relatively standard in
> > this case, is always good.
> 
> I looked at my lspci output and did a little researching, and I think
> the only thing we can deduce is that there is an LPC bridge, so
> looking for a SuperIO is a good idea. If there is no LPC bridge
> listed, I can't say whether probing the ports is a good idea or not.

Machines I have here have an "ISA bridge" PCI device. Some of them have
"LPC" in their name, but not all, and anyway the kernel only knows the
device ID, not its user-friendly name:

VIA:
00:11.0 ISA bridge: VIA Technologies, Inc. VT8237 ISA bridge [KT600/K8T800/K8T890 South]

Intel:
00:01.0 ISA bridge: Intel Corporation 82371AB/EB/MB PIIX4 ISA (rev 01)
00:1f.0 ISA bridge: Intel Corporation 82801CAM ISA Bridge (LPC) (rev 01)
00:1f.0 ISA bridge: Intel Corporation 82801EB/ER (ICH5/ICH5R) LPC Interface Bridge (rev 02)

nVidia:
00:01.0 ISA bridge: nVidia Corporation nForce2 ISA Bridge (rev a4)

One of these machines has a LPC bridge but no (detected) Super-I/O chip.

The VIA and nVidia machines do not have "LPC" in their bridge name, but
they do have a Super-I/O chip, while the first Intel machine doesn't.

As a conclusion, there is no clear relationship between the presence of
an ISA or LPC bridge and the presence of a Super-I/O chip. All we can
say is that apparently all PC systems have an ISA bridge. So indeed we
can probably make the probes conditional upon the presence of an "ISA
bridge" PCI device. That's very easy to test. In practice it might be
equivalent to making the driver x86-only.

-- 
Jean Delvare
