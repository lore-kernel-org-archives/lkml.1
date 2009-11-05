Return-Path: <linux-kernel-owner+w=401wt.eu-S1756737AbZKEPzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737AbZKEPzg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 10:55:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756631AbZKEPzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 10:55:35 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45033 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755984AbZKEPze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 10:55:34 -0500
Date: Thu, 5 Nov 2009 15:56:48 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: miklos@szeredi.hu, akpm@linux-foundation.org, viro@ZenIV.linux.org.uk,
       dhowells@redhat.com, hch@infradead.org, adilger@sun.com,
       mtk.manpages@gmail.com, torvalds@linux-foundation.org,
       drepper@gmail.com, jamie@shareable.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 resend] vfs: new O_NODE open flag
Message-ID: <20091105155648.4329f5b7@lxorguk.ukuu.org.uk>
In-Reply-To: <E1N64Ch-0003C6-Rn@pomaz-ex.szeredi.hu>
References: <E1N60RV-0002ed-FX@pomaz-ex.szeredi.hu>
	<20091105131545.72b4e319@lxorguk.ukuu.org.uk>
	<E1N63Io-000353-KX@pomaz-ex.szeredi.hu>
	<20091105145054.11f36b35@lxorguk.ukuu.org.uk>
	<E1N64Ch-0003C6-Rn@pomaz-ex.szeredi.hu>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Fortunately you can patch it by hand.
> 
> How do you patch it by hand?

I find "joe" quite useful, some people prefer vi or emacs

> All of this is about new and unexpected semantics.  I don't think
> anything more needs to be done than document it in the manpage:

It's a security changing behaviour. It's effectively a regression for
security and that is usually bad news.
 
>   "A file descriptor opened with O_NODE | O_NOACCESS may be used to
>    re-open the same file later with increased permissions
>    (e.g. O_RDWR) if the access mode allows.  This is true even if the
>    permissions on the path leading up to the file would prevent it"

Which is contrary to the assumptions made by systems designers for the
past forty years, so its a very dangerous assumption to break.

What are the sematics with regards to vhangup ?

What are the sematics of O_NODE opening a device file when the device is
later unloaded and a new device is created on the same node with totally
unrelated permissions ? [happens all the time btw]

> > But that isn't the case for some things - consider CIFS and other network
> > file systems.
> 
> Why?

open O_NODE
remote file moves
new one appears
reopen

Now what should happen and what does happen ?

> of the volume does not allow any access to the user, so normal
> open/chdir won't work.  Yet open(O_NODE) will and so user can pin the
> volume.

and without permission on the node.

> However, there's not all that much difference between the above and
> doing "stat()" on the mountpoint in a tight loop, except the former is
> a more reliable way to prevent unmounting.

That doesn't seem to be the case testing it, but its fixable trivially if
so and its fixable without API breakage. Its at worst an implementation
corner case. The O_NODE case is a real nasty API level problem,
particularly as Linux still lacks revoke().

In fact I'd say given the need to get rid of O_NODE references to an
object that you need revoke() first and that revoke must kill O_NODE
references to an object as well.

Alan
