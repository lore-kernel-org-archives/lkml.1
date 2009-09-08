Return-Path: <linux-kernel-owner+w=401wt.eu-S1753952AbZIHHiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbZIHHiR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 03:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753910AbZIHHiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 03:38:17 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:43902 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782AbZIHHiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 03:38:16 -0400
Message-ID: <4AA609E8.3060408@gmail.com>
Date: Tue, 08 Sep 2009 09:38:16 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Jike Song <albcamus@gmail.com>
CC: Parag Warudkar <parag.lkml@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: BUG UNIX: Poison overwritten with 2.6.31-rc6-00223-g6c30c53
References: <alpine.DEB.2.00.0909072323350.3940@parag-desktop> <df9815e70909072151l2686231en76773418aaf9deeb@mail.gmail.com>
In-Reply-To: <df9815e70909072151l2686231en76773418aaf9deeb@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 08 Sep 2009 09:38:17 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jike Song a écrit :
> On Tue, Sep 8, 2009 at 11:56 AM, Parag Warudkar<parag.lkml@gmail.com> wrote:
>> On Thu, Aug 27, 2009 at 4:45 PM, Jike Song<albcamus@gmail.com> wrote:
>>>> hi, I hit this with vnc. Below is part of dmesg :
>>> Still producible in 2.6.31-rc9, anybody helps?
>> How does one go about reproducing this? You said VNC triggers this but
>> what VNC version, server or client? What distro and what needs to be done
>> with VNC to trigger this problem? I ask since I use VNC myself and test -git kernels
>> and have not encountered this issue.
>>
>> Parag
>>
>>
> Thanks for your attention,  CC netdev this time.
> 
> VNC server: tigervnc-server-0.0.91-0.11.fc11.x86_64
> VNC client:  TurboVNC Viewer version 0.5 for Solaris
> Distro       : Fedora 11, x86-64
> 
> I specify gnome-init in xstartup, below is my xstartup file, with this
> file one only need to run vncviewer from the client to produce this
> bug:
> 
> #!/bin/sh
> 
> unset LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES
> unset LC_PAPER LC_NAME LC_ADDRESS LC_TELEPHONE LC_MEASUREMENT
> unset LC_IDENTIFICATION LC_ALL LANG LANGUAGE PAGER
> LANG=zh_CN.UTF-8
> export LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES
> export LC_PAPER LC_NAME LC_ADDRESS LC_TELEPHONE LC_MEASUREMENT
> export LC_IDENTIFICATION LC_ALL LANG LANGUAGE PAGER
> export G_FILENAME_ENCODING=@locale
> XMODIFIERS="@im=SCIM"
> GTK_IM_MODULE="scim"
> export XMODIFIERS GTK_IM_MODULE
> if type scim &> /dev/null ; then
> 	scim -d &
> fi
> 
> vncconfig -iconic &
> unset SESSION_MANAGER
> unset DBUS_SESSION_BUS_ADDRESS
> OS=`uname -s`
> if [ $OS = 'Linux' ]; then
>   case "$WINDOWMANAGER" in
>     *gnome*)
>       if [ -e /etc/SuSE-release ]; then
>         PATH=$PATH:/opt/gnome/bin
>         export PATH
>       fi
>       ;;
>   esac
> fi
> if [ -x /etc/X11/xinit/xinitrc ]; then
>   exec /etc/X11/xinit/xinitrc
> fi
> if [ -f /etc/X11/xinit/xinitrc ]; then
>   exec sh /etc/X11/xinit/xinitrc
> fi
> [ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
> xsetroot -solid grey
> xterm -geometry 1024x768 -ls -title "$VNCDESKTOP Desktop" &
> gnome-init &
> 
> 
> 

We decrement a refcnt while object already freed.

(SLUB DEBUG poisons the zone with 0x6B pattern)

You might add this patch to trigger a WARN_ON when refcnt >= 0x60000000U
in sk_free() : We'll see the path trying to delete an already freed sock

diff --git a/net/core/sock.c b/net/core/sock.c
index 7633422..1cb85ff 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1058,6 +1058,7 @@ static void __sk_free(struct sock *sk)

 void sk_free(struct sock *sk)
 {
+	WARN_ON(atomic_read(&sk->sk_wmem_alloc) >= 0x60000000U);
 	/*
 	 * We substract one from sk_wmem_alloc and can know if
 	* some packets are still in some tx queue.

