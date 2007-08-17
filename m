Return-Path: <linux-kernel-owner+w=401wt.eu-S1761338AbXHQVKG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761338AbXHQVKG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 17:10:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762946AbXHQVJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 17:09:41 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:46250 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762421AbXHQVJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 17:09:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QzW2gC3ILgz474vFcB4jO6LfSk6qA/96WmUccOoxY3jtHv7EFAdP5zQKEajaD5u0BQyxDZkz1yNAiEua5+SYbe3p6+OFpQXPI262NlqC0wlQZv4yP6+JJ/xDhv420usOiTNr3HLBfG9+s7GPBloO+0OsXA1DpuDGlu3SQ9Rkf28=
Message-ID: <8bd0f97a0708171409l39166daep185e89438f4104f0@mail.gmail.com>
Date: Fri, 17 Aug 2007 17:09:39 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Robin Getz" <rgetz@blackfin.uclinux.org>
Subject: Re: Early printk behaviour
Cc: "Gerd Hoffmann" <kraxel@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <200708171700.29647.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200708152234.06734.rgetz@blackfin.uclinux.org>
	 <8bd0f97a0708160947x3bd308abmc4f3b523e2444586@mail.gmail.com>
	 <46C552FB.4000508@redhat.com>
	 <200708171700.29647.rgetz@blackfin.uclinux.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/17/07, Robin Getz <rgetz@blackfin.uclinux.org> wrote:
> On Fri 17 Aug 2007 03:49, Gerd Hoffmann pondered:
> > Mike Frysinger wrote:
> > >> Hmm, sort of, although I didn't think about the case of no real console
> > >> replacing the early console.  The intention of the patch is to have a
> > >> smooth handover from the boot console to the real console.  And, yes, if
> > >> no real console is ever registered the boot console keeps running ...
> > >
> > > i think it also occurs in the case where real console != early console
> >
> > No.  At least not of the boot console has the CON_BOOT flag set as it
> > should.  Last message you'll see on the boot console is the handover
> > printk, telling you which real console device prints the following
> > messages.  Whenever early and real console go to the physical device or
> > not doesn't matter.
> >
> > >> So you can either let it running and *not* mark it __init, so it can
> > >> keep on going without breaking.  Or you can explicitly unregister your
> > >> boot console at some point, maybe using a late_initcall.
> > >
> > > wouldnt a common kernel late_initcall() be more appropriate ?  if
> > > early console hasnt switched over (for whatever reason), then kill it
> >
> > Hmm, yes, should be doable in generic code.  Check whenever the current
> > console has CON_BOOT set and if so unregister it.
>
> Something like:
>
> Index: kernel/printk.c
> ===================================================================
> --- kernel/printk.c     (revision 3568)
> +++ kernel/printk.c     (working copy)
> @@ -1104,6 +1104,22 @@
>  }
>  EXPORT_SYMBOL(unregister_console);
>
> +int __init disable_boot_consoles(void)
> +{
> +       struct console *con;
> +
> +       for (con = console_drivers; con; con = con->next) {
> +               if (con->flags & CON_BOOT) {
> +                       printk(KERN_INFO "Unregister BootConsole %s%d\n",
> +                               con->name, con->index);
> +                       unregister_console(con);
> +               }
> +       }
> +       return 0;
> +}
> +late_initcall(disable_boot_consoles);

is there any need for a return value then ?
void __init disable_boot_consoles(void);

and if we dont think anyone else wants to call it ...
static void __init disable_boot_consoles(void);
-mike
