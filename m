Return-Path: <linux-kernel-owner+w=401wt.eu-S1759066AbXF3OiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759066AbXF3OiT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 10:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756918AbXF3OiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 10:38:06 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:51825 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756854AbXF3OiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 10:38:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Ss4LzS0uvoLy2YR3g+h6AI77AjCp0eTQ8q9Js3GL5Hv4YnfjDKtCOl+9VwQ0MMD+AXz/KvFSIbK4YQNHW35ogFUN3RO7C3WphS+Q+Lvj54W9HqeSPVZH9lMfZsWfatbv/kMrTXCXQH2/qMTyL5gKia2mDBhvAkdTeLl0wRTMk2I=
Message-ID: <a781481a0706300738g2e92d959qeb50bebdf34db13f@mail.gmail.com>
Date: Sat, 30 Jun 2007 20:08:01 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Steve French" <smfrench@gmail.com>
Subject: Re: [PATCH] CIFS: make cifsd (more)
Cc: "Jeff Layton" <jlayton@redhat.com>,
       "Christoph Hellwig" <hch@infradead.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <524f69650706300632p1f4fb3e0l23bd017672b77baf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <524f69650706251525g7b17ea02o5fb3e637615fe542@mail.gmail.com>
	 <20070630084209.GA21186@infradead.org>
	 <20070630071514.514d4833.jlayton@redhat.com>
	 <524f69650706300632p1f4fb3e0l23bd017672b77baf@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ Trimmed Cc: list ]

On 6/30/07, Steve French <smfrench@gmail.com> wrote:
> The reason that cifs switched from wait_for_completion to the kthread
> call to cifs_demultiplex_thread in the first place is because without
> use of kthread it won't work with a linux-vserver.   See the thread:
>
> http://marc.info/?l=linux-cifs-client&m=117552761703381&w=2
>
> If we take out the kthread call, we break those guys.
>
> I agree that using sk_callbacks is worth looking into - I only found
> ocfs2 and SunRPC (NFS) though that used it.   Is there a better
> example though?   The NFS socket handling code is huge
> (net/sunrpc/xprtsck.c) - something seems wrong when replacing a few
> lines of code with a new 1675 line file.  There must be a better
> example of doing what you suggest...

You're correct. "Right" / "elegant" solutions are rarely (if ever?) complex
and involved. Simplicity _is_ good. I see no point in converting 5 good
lines of maintainable, readable, solid code with 1000 lines of kludge :-)
just to work-around this kthreads limitation. But then, of course, the call
is yours.

> I am tempted to drop the socket timeout (which cifs sets to 7 seconds)
> to a smaller number and not use signals at all rather than add that
> much complexity

Timeout too low => CPU wastage => power wastage. [ Think laptop
batteries, with say 5 cifsd kthreads waking up once every second ... ]
Timeout too high => umount(2) hangs, annoys user, user takes
drastic actions ... so think of some good "magic number" :-)

I don't quite think of all these suggestions as solutions at all -- they
are workarounds at best, IMHO (for kthread's limitation in dealing with
kernel threads that want to block -- I still don't see any fundamental
reasoning / logic behind why kthreads should be banned from doing
blocking recv's -- if there is, please let me know too).

Don't have much else to say than what I already have on the two
threads discussing this.

Satyam
