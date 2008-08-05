Return-Path: <linux-kernel-owner+w=401wt.eu-S1754175AbYHEEna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbYHEEna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 00:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbYHEEnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 00:43:20 -0400
Received: from smtp119.mail.mud.yahoo.com ([209.191.84.76]:33242 "HELO
	smtp119.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751217AbYHEEnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 00:43:19 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=eQFGpZOJZegMAxqJD2h/MDgUlbv4UCWHgJpQiddVrN9jeVTqBJP84zu9rf4RT/gQOSso1zP/V8dI/Yvl0+cdb+03JOpBiVUrsA/WrTXSMLji45eURnUBYwixBNMzdPSdpDzhExGEf6dsX0hhFbS94pQfzFkVoRIu/VI31UDKcqM=  ;
X-YMail-OSG: CgSWX7kVM1ngKoVP2gPwYyW9UfbVYD0LQukpU_jQFmIN_PIGuoyIbKK9JpNlBM8jFi7T0PEALR5idBHvqY.NY3Xw44vBidhCPUk_q3.bMzeWaETL1z.tegPLZPdA_CnQHHk-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Keith Packard <keithp@keithp.com>
Subject: Re: [PATCH] Export shmem_file_setup and shmem_getpage for DRM-GEM
Date: Tue, 5 Aug 2008 14:43:11 +1000
User-Agent: KMail/1.9.5
Cc: Christoph Hellwig <hch@infradead.org>, Eric Anholt <eric@anholt.net>,
       linux-kernel@vger.kernel.org
References: <1217573919-7496-1-git-send-email-eric@anholt.net> <200808041902.23970.nickpiggin@yahoo.com.au> <1217887116.24714.118.camel@koto.keithp.com>
In-Reply-To: <1217887116.24714.118.camel@koto.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808051443.11858.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 August 2008 07:58, Keith Packard wrote:
> On Mon, 2008-08-04 at 19:02 +1000, Nick Piggin wrote:
> > > I suppose we could have user space allocate the shmem file (either via
> > > tmpfs or sysv ipc). tmpfs suffers from the maxfd issue, while sysv ipc
> > > runs up against the SHMMAX value.
> >
> > This is how I'd suggested it work as well. I think a little bit
> > more effort should be spent looking at making this work.
>
> Well, I've spent a day thinking about using existing user-space APIs to
> get at shmem files. While it's nice that we've discovered a
> filesystem-independent mechanism to pin file pages, we haven't found
> anything similar for creating the files. In particular, what I want is:
>
>  1) Anonymous files backed by swap
>  2) Freed when the last process using them exits
>  3) That never appear in the file system
>  4) Do not consume a low FD (yeah, I know, rewrite the desktop)
>
> So, what I could do is
>
> 	char	template[] = "/dev/shm/drm-XXXXXX";
> 	int	fd;
> 	fd = mkstemp (template);
> 	unlink (template);
> 	ftruncate (fd, size)
> 	object = drm_create_an_object_for_a_file (fd);
> 	close (fd);
>
> While I haven't written any code yet, this should work and will even be
> compatible with my current user-space API. I have to create a DRM object
> for the file in any case, and so I don't need to hold onto the fd.
> Releasing the fd also eliminates any ulimit issues.
>
> The drm_create_an_object_for_a_file call could return another fd. But,
> note that the original shmem fd has no real value to the application in
> this case.
>
> I can imagine other cases where mapping non-shmem files would make sense
> though, in particular it's fairly easy to envision mapping an image file
> to the GTT and having the graphics process decode and display it without
> any additional copies. I think this demonstrates the potential utility
> of the general file mapping operation.
>
> But, I'd like to have you reconsider whether it makes sense for user
> space to go through the above dance to create anonymous shared objects
> when the kernel already supports precisely the desired semantics and
> even exposes them to the ipc/shm implementation.

In my opinion, doing this little song and dance (which is a few lines
of quite well defined APIs, btw) in userspace is preferable to adding
a single line or exporting a single function in kernel space. Unless
there is a better reason than eliminating a few lines of userspace code.

I'm absolutely not against exporting a nice API for a swappable, object
based memory allocator using ipc or shm to the wider kernel (with a nice
API rather than just using shmem functions directly of course). But the
fact that most or all of this seems to be able to be done in userspace
just tells me that's where it should be prototyped first. It adds
nothing to maintainence costs of the kernel code, and might actually be
helpful to show some shortcomings of our user API definition or
implementation.

In the worst case it completely fails, the effort will still show much
better how and why it needs to be done in kernel.
