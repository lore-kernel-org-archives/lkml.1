Return-Path: <linux-kernel-owner+w=401wt.eu-S1755473AbYGWS5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473AbYGWS5S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 14:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753508AbYGWS5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 14:57:04 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:18352 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170AbYGWS5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 14:57:03 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "Fabio Comolli" <fabio.comolli@gmail.com>
Subject: Re: New conflict message in latest GIT
Date: Wed, 23 Jul 2008 12:56:42 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       Rene Herman <rene.herman@keyaccess.nl>, Andrew Morton <akpm@osdl.org>,
       Thomas Renninger <trenn@suse.de>, Jean Delvare <khali@linux-fr.org>
References: <b637ec0b0807221156x46d550a1h4180d6d624daeeb@mail.gmail.com>
In-Reply-To: <b637ec0b0807221156x46d550a1h4180d6d624daeeb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807231256.42743.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 July 2008 12:56:36 pm Fabio Comolli wrote:
> Linus' GIT tree 2.6.26-05752-g93ded9b shows this message:
> 
> i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
> ACPI: I/O resource 0000:00:1f.3 [0x18e0-0x18ff] conflicts with ACPI
> region SMBI [0x18e0-0x18ef]
> ACPI: Device needs an ACPI driver
> 
> There is no equivalent in 2.6.26 or previous kernels.

The "ACPI: I/O resource ... conflicts with ..." message was added by
Thomas:
  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=df92e695998e1bc6e426a840eb86d6d1ee87e2a5

That conflict checking infrastructure was in 2.6.26, but Jean's
change to make the i801_smbus driver use it didn't happen until
about a week ago:
  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=54fb4a05af0a4b814e6716cfdf3fa97fc6be7a32

The message is telling us that the i801_smbus driver thinks it owns
the 0x18e0-0x18ff region, but there's also an ACPI opregion that
references that region.  There's no coordination between ACPI and
the i801_smbus driver, so there may be issues where nearly
simultaneous accesses cause incorrect behavior, e.g,. one may
read the wrong value from a temperature sensor.  That, of course,
can lead to more serious things like unintended machine shutdowns.

I don't have any ideas about how to address this.  I think Thomas's
intent was to collect better information for unreproducible bugs.
(Maybe this sort of conflict should even set a taint flag?)

Bjorn

