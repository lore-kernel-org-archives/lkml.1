Return-Path: <linux-kernel-owner+w=401wt.eu-S965865AbXCLN4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965865AbXCLN4F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 09:56:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965868AbXCLN4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 09:56:05 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:53155 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965871AbXCLN4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 09:56:03 -0400
Date: Mon, 12 Mar 2007 13:53:51 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, perex@suse.cz,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [SOUND] hda_intel: build fix
Message-ID: <20070312135351.GA11974@linux-mips.org>
References: <20070310190513.GA24435@linux-mips.org> <s5h8xe2soxt.wl%tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h8xe2soxt.wl%tiwai@suse.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2007 at 12:04:30PM +0100, Takashi Iwai wrote:

> It's no big problem to remove const in these cases, but allowing const
> with __devinitdata seems the right fix to me...

Gccs derives the readability of a section used with __attribute(section())
from the first use, which in case of this driver was a non-const use, so
gcc made .init.data a r/w section.  Later uses were marked with const,
so did conflict.  Having to ensure that all members of a section are const
or are not const is painful, so this is clearly less than desirable
behaviour on gcc's side.  I think gcc picking the most permissive
attributes for a section, that is r/w in this case would be far preferable.

Here is a small test case btw:

int foo __attribute__ ((__section__ (".init.data"))) = 23;
const int bar __attribute__ ((__section__ (".init.data"))) = 42;

Now I'm not a great fan of the patch I've posted but it reflects what real
world gcc is doing so for the time being I don't see much of a chance to
The Right Thing (TM).  And the gain from const in this case will be small
anyway.

  Ralf
