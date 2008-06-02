Return-Path: <linux-kernel-owner+w=401wt.eu-S1758768AbYFBMOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768AbYFBMOP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 08:14:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752986AbYFBMOB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 08:14:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47888 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649AbYFBMOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 08:14:00 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Thomas Gleixner <tglx@linutronix.de>,
       xen-devel <xen-devel@lists.xensource.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] Re: [PATCH 08 of 12] xen-console: add save/restore
References: <patchbomb.1211550067@localhost>
	<d9561e802a69a3ca269c.1211550075@localhost>
	<20080602111720.GC18586@elte.hu>
From: Markus Armbruster <armbru@redhat.com>
Date: Mon, 02 Jun 2008 14:13:19 +0200
In-Reply-To: <20080602111720.GC18586@elte.hu> (Ingo Molnar's message of "Mon\, 2 Jun 2008 13\:17\:20 +0200")
Message-ID: <87ve0shw68.fsf@pike.pond.sub.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> -tip testing found the following xen-console symbols trouble:
>
>  ERROR: "console_drivers" [drivers/video/xen-fbfront.ko] undefined!
>  ERROR: "get_phys_to_machine" [drivers/video/xen-fbfront.ko] undefined!
>  ERROR: "get_phys_to_machine" [drivers/net/xen-netfront.ko] undefined!
>  ERROR: "get_phys_to_machine" [drivers/input/xen-kbdfront.ko] undefined!
>
> with:
>
>   http://redhat.com/~mingo/misc/config-Mon_Jun__2_12_26_38_CEST_2008.bad
>
> get_phys_to_machine can indeed be exported but i'm less sure about the 
> console_drivers export ... The temporary fix below resolves it for now.
>
> 	Ingo

xen-fbfront makes itself the preferred console when it is actually
enabled.  It does that by re-registering itself with CON_CONSDEV set,
and for that it needs to find its struct console.  Simple, works.
Perhaps you can think of a better solution for this problem.  I'm all
ears!

Details are in this commit:

    xen: Enable console tty by default in domU if it's not a dummy
    
    Without console= arguments on the kernel command line, the first
    console to register becomes enabled and the preferred console (the one
    behind /dev/console).  This is normally tty (assuming
    CONFIG_VT_CONSOLE is enabled, which it commonly is).
    
    This is okay as long tty is a useful console.  But unless we have the
    PV framebuffer, and it is enabled for this domain, tty0 in domU is
    merely a dummy.  In that case, we want the preferred console to be the
    Xen console hvc0, and we want it without having to fiddle with the
    kernel command line.  Commit b8c2d3dfbc117dff26058fbac316b8acfc2cb5f7
    did that for us.
    
    Since we now have the PV framebuffer, we want to enable and prefer tty
    again, but only when PVFB is enabled.  But even then we still want to
    enable the Xen console as well.
    
    Problem: when tty registers, we can't yet know whether the PVFB is
    enabled.  By the time we can know (xenstore is up), the console setup
    game is over.
    
    Solution: enable console tty by default, but keep hvc as the preferred
    console.  Change the preferred console to tty when PVFB probes
    successfully, unless we've been given console kernel parameters.
    
    Signed-off-by: Markus Armbruster <armbru@redhat.com>

[...]
