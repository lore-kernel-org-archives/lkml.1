Return-Path: <linux-kernel-owner+w=401wt.eu-S964819AbYA2UM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964819AbYA2UM5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 15:12:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756993AbYA2UMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 15:12:46 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:37135 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755751AbYA2UMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 15:12:44 -0500
Date: Tue, 29 Jan 2008 21:12:45 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: [RFC] __ref annotation of function/data referencing __init/__exit
Message-ID: <20080129201245.GA14857@uranus.ravnborg.org>
References: <20080126184454.GA25591@uranus.ravnborg.org> <20080128213811.GE3842@uranus.ravnborg.org> <Pine.LNX.4.64.0801292053531.14907@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801292053531.14907@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2008 at 08:55:32PM +0100, Jan Engelhardt wrote:
> 
> On Jan 28 2008 22:38, Sam Ravnborg wrote:
> >On Sat, Jan 26, 2008 at 07:44:54PM +0100, Sam Ravnborg wrote:
> >> Today we have the following annotations for functions/data
> >> referencing __init/__exit functions / data:
> >> 
> >> __init_refok for functions
> >> __initdata_refok for data
> >> 
> >> and
> >> _exit_refok for functions
> >> 
> >> To simplify it and to introduce a shorter annotation I
> >> will suggest the following annotation:
> >> 
> >> __ref      <= for functions (code) that
> >>               references __*init / __*exit
> >> __refdata  <= for variables
> >> __refconst <= for const variables
> >>
> >
> >This patch was includedin todays kbuild.git submission
> >as I heard no negative feedback.
> 
> I would like to see some real-world example of __ref*.
> When would you want to "reference" (function pointer?) an __init
> function from outside another __init function?

It replaces the old __init_Refok - so you can just grep for that one.
One obvious example:

init/main.c:static void noinline __init_refok rest_init(void)

Here we jump from the the __init part to the normal operation.

And
static noinline __init_refok
int zone_wait_table_init(struct zone *zone, unsigned long zone_size_pages)
{
       ...
      if (system_state == SYSTEM_BOOTING) {
                zone->wait_table = (wait_queue_head_t *)
                        alloc_bootmem_node(pgdat, alloc_size);

The program logic guarantee that we only call
alloc_bootmem_node when we are in the init phase.
So to silence the warning we added __init_refok that is
now named __ref.

We have plenty of data structures containing pointers to
functions annotated __*init or __*exit.

One that casues a lot of warnings is pci_serial_quirks.

Here we can use the annotation to tell modpost that
the references are OK like this (see __refdata):

static struct pci_serial_quirk pci_serial_quirks[] __refdata = {
	...
                .exit           = __devexit_p(sbs_exit),
        },


thout the annotation modpost would complain about the
reference to sbs_exit because sbs_exit is annotated __devexit.

If you have proposals to improve the commeonts in init.h please let
me know. This seems to confuse a lot of people.

	Sam
