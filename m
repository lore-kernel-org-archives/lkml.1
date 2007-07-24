Return-Path: <linux-kernel-owner+w=401wt.eu-S1758523AbXGXTDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758523AbXGXTDu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 15:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965AbXGXTDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 15:03:43 -0400
Received: from gw.goop.org ([64.81.55.164]:37709 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590AbXGXTDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 15:03:42 -0400
Message-ID: <46A64CD5.2030800@goop.org>
Date: Tue, 24 Jul 2007 12:02:45 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Tilman Schmidt <tilman@imap.cc>
CC: Olaf Hering <olh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Gabriel C <nix.or.die@googlemail.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: 2.6.22-git17 boot failure
References: <46A3EC92.3050504@imap.cc> <46A3FBB7.9000608@imap.cc> <46A46BF9.6010906@goop.org> <46A481FD.2030607@imap.cc> <46A4C081.6070305@goop.org> <46A504A3.3070205@imap.cc> <46A51079.5030006@goop.org> <46A53396.2060902@imap.cc> <46A5444D.4080304@goop.org> <20070724091018.GA26724@one.firstfloor.org> <20070724095614.GB625@suse.de> <46A64019.4010508@imap.cc>
In-Reply-To: <46A64019.4010508@imap.cc>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tilman Schmidt wrote:
> Alright, I know what's going on now, and it looks like a problem with
> the Opensuse init script. In fact, the initrd for the Xen enabled
> kernel got a *different* init script than the one for the non-Xen one.
> The difference being:
>   

Phew, I was getting worried there for a minute.  Does the install script
check for CONFIG_XEN in the kernel config or something?

> --- /tmp/testing/init   2007-07-24 15:53:58.000000000 +0200
> +++ /tmp/xentest/init   2007-07-24 15:54:16.000000000 +0200
> @@ -308,6 +308,9 @@
>      fi
>  fi
>
> +caps="$(</proc/xen/capabilities)"
> +if [ "$caps" != "${caps%control_d*}" ]; then
> +
>  params=
>  for p in $(cat /proc/cmdline) ; do
>    case $p in
> @@ -509,6 +512,32 @@
>  echo "Loading dm-snapshot"
>  modprobe dm-snapshot $params
>
> +else
> +
> +params=
> +for p in $(cat /proc/cmdline) ; do
> +  case $p in
> +    dm-mod.*)
> +      params="$params ${p#dm-mod.}"
> +      ;;
> +  esac
> +done
> +echo "Loading dm-mod"
> +modprobe dm-mod $params
> +
> +params=
> +for p in $(cat /proc/cmdline) ; do
> +  case $p in
> +    dm-snapshot.*)
> +      params="$params ${p#dm-snapshot.}"
> +      ;;
> +  esac
> +done
> +echo "Loading dm-snapshot"
> +modprobe dm-snapshot $params
> +
> +fi
> +
>  echo -n "Waiting for /dev/mapper/control to appear: "
>  for i in 1 2 3 4 5; do
>      [ -e /dev/mapper/control ] && break
>
> In clear: the Xen init script reads /proc/xen/capabilities and if it
> doesn't find the magic string "control_d" in it, willfully *skips*
> loading all the SCSI and ATA stuff.
>
> The missing piece then is the innocent little line:
>
> /init: line 311: /proc/xen/capabilities: No such file or directory
>
> appearing on my screen during boot ... BOOM!
>
> If I just diligently type all the skipped modprobe commands
>
> $ modprobe scsi_mod
> $ modprobe sd_mod
> $ modprobe processor
> $ modprobe thermal
> $ modprobe libata
> $ modprobe ahci
> $ modprobe pata_marvell
> $ modprobe scsi_transport_spi
> $ modprobe aic7xxx
> $ modprobe fan
> $ modprobe edd
> $ ^D
>
> into the fallback shell by hand, the system comes up without further ado.
>
> So there, case solved. Now you sort it out who's to fix what. :-)
>   

Well, definitely on the suse side.  I don't think there's any point in
me renaming CONFIG_XEN to something less obvious to avoid this
breakage.  I guess the proper fix is to carry on as if its a native boot
if /proc/xen/* is missing, since they'll never be there when not booting
under Xen (and unlikely to be there in a paravirt-xen boot anyway).

    J
