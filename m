Return-Path: <linux-kernel-owner+w=401wt.eu-S1762845AbYBGXKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762845AbYBGXKz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 18:10:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757011AbYBGXKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 18:10:47 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40469 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756597AbYBGXKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 18:10:46 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [rft] s2ram wakeup moves to .c, could fix few machines
Date: Fri, 8 Feb 2008 00:09:04 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>
References: <20080205190600.GB11613@elf.ucw.cz> <47AB8A41.3040008@zytor.com> <20080207225121.GE6096@elf.ucw.cz>
In-Reply-To: <20080207225121.GE6096@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802080009.04666.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 7 of February 2008, Pavel Machek wrote:
> On Thu 2008-02-07 14:46:25, H. Peter Anvin wrote:
> > Pavel Machek wrote:
> >>
> >> This is probably more acceptable version of beep; but there are
> >> probably even better ways to clean it...
> >>
> >>         if (wakeup_header.realmode_flags & 4) {
> >>                 inb(97);
> >>                 outb(0, 0x80);
> >>                 outb(3, 97);
> >>                 outb(0, 0x80);
> >>                 outb(-74, 67);
> >>                 outb(0, 0x80);
> >>                 outb(-119, 66);
> >>                 outb(0, 0x80);
> >>                 outb(15, 66);
> >>         }
> >>
> >
> > What is available at this point -- are BIOS calls still accessible; are 
> > interrupts running?
> 
> No interrupts. BIOS calls work on some machines, but I'd like this to
> work when bios does not.
> 
> Actually, matthieu's code is probably better to start from:
> 
> +/* one ISA cycle @8Mhz */
> +#define PAUSE outb %al, $0x80
> +#define WAIT_100MS \
> +       movl $800000, %eax; \
> +       2: \
> +       PAUSE; \
> +       dec %eax; \
> +       jne 2b
> +
> +/* What's the PIT rate */
> +#define COUNT 0xf89
>  #define BEEP \
> -       inb     $97, %al;       \
> -       outb    %al, $0x80;     \
> -       movb    $3, %al;        \
> -       outb    %al, $97;       \
> -       outb    %al, $0x80;     \
> -       movb    $-74, %al;      \
> -       outb    %al, $67;       \
> -       outb    %al, $0x80;     \
> -       movb    $-119, %al;     \
> -       outb    %al, $66;       \
> -       outb    %al, $0x80;     \
> -       movb    $15, %al;       \
> -       outb    %al, $66;
> +       /* enable counter 2 */ \
> +       inb             $0x61, %al;     \
> +       PAUSE;  \
> +       orb     $3, %al; \
> +       outb    %al, $0x61;     \
> +       PAUSE;  \
> +       /* set command for counter 2, 2 byte write */ \
> +       movb    $0xB6, %al;     \
> +       outb    %al, $0x43;     \
> +       PAUSE;  \
> +       /* select desired HZ */ \
> +       movb    $(COUNT & 0xff), %al; \
> +       outb    %al, $0x42;     \
> +       PAUSE;  \
> +       movb    $(COUNT >> 8), %al;     \
> +       outb    %al, $0x42; \
> +       WAIT_100MS; \
> +       /* disable counter 2 */ \
> +       inb             $0x61, %al;     \
> +       PAUSE;  \
> +       andb    $0xFC, %al; \
> +       outb    %al, $0x61; \
> +       WAIT_100MS
> +
> +#define CBEEP \
> +       testl   $4, realmode_flags - wakeup_code; \
> +       jz      1f; \
> +       BEEP; \
> +1:
> 
> ...because it allows user to compute number of beeps.

Hm, it seems we can convert it at least partially to C.

Rafael
