Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963Ab0BAKMs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 05:12:48 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:41044 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab0BAKMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 05:12:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=pE5teg5HGH4vpHAbTr5ykre4YSlEqMUDlqui2flED4dxQVoulUOxxpqXjiClkVPSIO
         4oKVnmmUpTW/1lA8SrJ9FeuRVfGN0A7c1iLde+XWsRZO7sWSWQPlAp/viAQkpM4bqZvK
         2Gwd4UaY4V6TJlrwcpdw2qcik+akwIzOxaQO8=
Subject: Re: debug: nt_conntrack and KVM crash
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Jon Masters <jonathan@jonmasters.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>,
       netfilter-devel <netfilter-devel@vger.kernel.org>,
       Patrick McHardy <kaber@trash.net>
In-Reply-To: <b6fcc0a1002010136k7e78a998p31a9e7464c2e8d44@mail.gmail.com>
References: <1264813832.2793.446.camel@tonnant>
	 <1264816634.2793.505.camel@tonnant> <1264816777.2793.510.camel@tonnant>
	 <1264834704.2919.3.camel@edumazet-laptop>
	 <1265016745.7499.144.camel@tonnant>
	 <b6fcc0a1002010136k7e78a998p31a9e7464c2e8d44@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Feb 2010 11:12:40 +0100
Message-ID: <1265019160.2848.14.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 01 février 2010 à 11:36 +0200, Alexey Dobriyan a écrit :
> On Mon, Feb 1, 2010 at 11:32 AM, Jon Masters <jonathan@jonmasters.org> wrote:
> > I hacked up a per-namespace version of hashtables (this needs doing
> > anyway, since the global stuff is just waiting to break)
> 
> Which ones? Conntrack hashtables are per-netns.

It seems they are, but this is not a complete work :

1) Global settings (shared by all netns)
2) nf_conntrack_cachep is shared, it should be not shared.
3) nf_conntrack_untracked shared by all netns, it should be local.

nf_conntrack_cleanup_net() can block forever because of this.

while (atomic_read(&nf_conntrack_untracked.ct_general.use) > 1)
	schedule();

...


