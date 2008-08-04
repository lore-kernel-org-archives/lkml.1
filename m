Return-Path: <linux-kernel-owner+w=401wt.eu-S1764514AbYHDWWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764514AbYHDWWY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 18:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750963AbYHDWWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 18:22:15 -0400
Received: from wr-out-0506.google.com ([64.233.184.238]:61295 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbYHDWWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 18:22:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=AVSQGfM6X22dKHPAwkmIYwJi6qmdqSrAYyIXEl+f7011D+/qvw3snR+W3IZPTK6LrA
         09iJwS0Wu1X8VQD87Yt8jsQXBicTyMokpcj2voWH8CpqZWo6lC/ANd+ExfgtCL66lWcn
         8ehDOaihwWBMtzNLkiBjMLrZMrxX+4FdWaAhI=
Message-ID: <21d7e9970808041522v63bc420o26ce6397ffab3870@mail.gmail.com>
Date: Tue, 5 Aug 2008 08:22:11 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Keith Packard" <keithp@keithp.com>
Subject: Re: [PATCH] Export shmem_file_setup and shmem_getpage for DRM-GEM
Cc: "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Eric Anholt" <eric@anholt.net>, linux-kernel@vger.kernel.org
In-Reply-To: <1217887116.24714.118.camel@koto.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1217573919-7496-1-git-send-email-eric@anholt.net>
	 <20080801205052.GA28747@infradead.org>
	 <1217814896.23437.420.camel@koto.keithp.com>
	 <200808041902.23970.nickpiggin@yahoo.com.au>
	 <1217887116.24714.118.camel@koto.keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 5, 2008 at 7:58 AM, Keith Packard <keithp@keithp.com> wrote:
> On Mon, 2008-08-04 at 19:02 +1000, Nick Piggin wrote:
>
>> > I suppose we could have user space allocate the shmem file (either via
>> > tmpfs or sysv ipc). tmpfs suffers from the maxfd issue, while sysv ipc
>> > runs up against the SHMMAX value.
>>
>> This is how I'd suggested it work as well. I think a little bit
>> more effort should be spent looking at making this work.
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
>        char    template[] = "/dev/shm/drm-XXXXXX";
>        int     fd;
>        fd = mkstemp (template);
>        unlink (template);
>        ftruncate (fd, size)
>        object = drm_create_an_object_for_a_file (fd);
>        close (fd);
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
>
> We'd offer two paths in DRM -- one that used an existing file and
> created an object using that as backing store, and a second one that
> created anonymous objects using shmem as backing store. Transient data
> would use anonymous objects while applications could directly map
> arbitrary file contents as well.

We also have a need to create in-kernel objects for things like fbcon.
If we cannot
create these without doing a major dance around the vfs then it'll be
rather ugly.

Dave.
