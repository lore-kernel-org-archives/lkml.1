Return-Path: <linux-kernel-owner+w=401wt.eu-S1752964AbZKCMl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbZKCMl5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 07:41:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751992AbZKCMl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 07:41:56 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:65402 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbZKCMlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 07:41:55 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCHv6 1/3] tun: export underlying socket
Date: Tue, 3 Nov 2009 13:41:31 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       linux-mm@kvack.org, akpm@linux-foundation.org, hpa@zytor.com,
       gregory.haskins@gmail.com, Rusty Russell <rusty@rustcorp.com.au>,
       s.hetze@linux-ag.com
References: <cover.1257193660.git.mst@redhat.com> <200911031312.33580.arnd@arndb.de> <20091103123112.GA4961@redhat.com>
In-Reply-To: <20091103123112.GA4961@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911031341.31622.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19gMTJNVdl4C3An8H/tWhK/yopNrRJvLwvZXUn
 15RA3pIvpNKvO0YKh/yDTDoRSUScPzIdnQMTVTDEPlY3ZWGK3u
 ztTPqL/vAqh45m9oYw5og==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 November 2009, Michael S. Tsirkin wrote:
> > What was your reason for changing?
> 
> It turns out socket structure is really bound to specific a file, so we
> can not have 2 files referencing the same socket.  Instead, as I say
> above, it's possible to make sendmsg/recvmsg work on tap file directly.

Ah, I see.

> I have implemented this (patch below), but decided to go with the simple
> thing first.  Since no userspace-visible changes are involved, let's do
> this by small steps: it will be easier to figure out when vhost
> is upstream.

This may even make it easier for me to do the same with macvtap
if I resume work on that.

> @@ -416,8 +422,8 @@ int sock_map_fd(struct socket *sock, int flags)
>  
>  static struct socket *sock_from_file(struct file *file, int *err)
>  {
> -       if (file->f_op == &socket_file_ops)
> -               return file->private_data;      /* set in sock_map_fd */
> +       if (file->f_op->get_socket)
> +               return file->f_op->get_socket(file);
>  
>         *err = -ENOTSOCK;

Or maybe do both (socket_file_ops and get_socket), to avoid an indirect
function call.

	Arnd <><
