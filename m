Return-Path: <linux-kernel-owner+w=401wt.eu-S1757463AbZBJW6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463AbZBJW6T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 17:58:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755548AbZBJW6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 17:58:08 -0500
Received: from outbound-mail-156.bluehost.com ([67.222.39.36]:47163 "HELO
	outbound-mail-156.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754527AbZBJW6H convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 17:58:07 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=bCtt12pdCNWSR6cRtY4RthhxnXQHLesBKDWR9aW/wowWeUl4eWOZ0WbiP6KPciRqyHSoOX2viH1lEdPBb3jbrbSlg0pDxxgpMhmtOHxhNql+4Yp4gVbiVZOBDJJ1Kt9o;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Eric Anholt <eric@anholt.net>
Subject: Re: Gem GTT mmaps..
Date: Tue, 10 Feb 2009 14:58:00 -0800
User-Agent: KMail/1.9.10
Cc: Thomas =?iso-8859-15?q?Hellstr=F6m?= <thomas@shipmail.org>,
       DRI <dri-devel@lists.sourceforge.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <498A1760.7010108@shipmail.org> <200902061424.02906.jbarnes@virtuousgeek.org> <1234303201.32506.8.camel@gaiman>
In-Reply-To: <1234303201.32506.8.camel@gaiman>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200902101458.01157.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 10, 2009 2:00 pm Eric Anholt wrote:
> On Fri, 2009-02-06 at 14:24 -0800, Jesse Barnes wrote:
> > On Friday, February 6, 2009 1:35 pm Thomas Hellström wrote:
> > > Jesse Barnes wrote:
> > > > On Thursday, February 5, 2009 10:37 am Jesse Barnes wrote:
> > > >> So if we leave the lookup reference around from the GTT mapping
> > > >> ioctl, that would take care of new mappings.  And if we
> > > >> added/removed references at VM open/close time, we should be covered
> > > >> for fork.  But is it ok to add a new unref in the finish ioctl for
> > > >> GTT mapped objects?  I don't think so, because we don't know for
> > > >> sure if the caller was the one that created the new fake offset
> > > >> (which would be one way of detecting whether it was GTT mapped).
> > > >> Seems like we need a new unmap ioctl?  Or we could put the mapping
> > > >> ref/unref in libdrm, where it would be tracked on a per-process
> > > >> basis...
> > > >
> > > > Ah but maybe we should just tear down the fake offset at unmap time;
> > > > then we'd be able to use it as an existence test for the mapping and
> > > > get the refcounting right.  The last thing I thought of was whether
> > > > we'd be ok in a map_gtt -> crash case.  I *think* the vm_close code
> > > > will deal with that, if we do a deref there?
> > >
> > > Yes, an mmap() is always paired with a vm_close(), and the vm_close()
> > > also happens in a crash situation.
> >
> > This one should cover the cases you found.
> >   - ref at map time will keep the object around so fault shouldn't fail
> >   - additional threads will take their refs in vm_open/close
> >   - unmap will unref and remove mmap_offset allowing object to be freed
>
> sw_finish doesn't mean unmap (note that it doesn't actually unmap).
>
> If you want to actually unmap, that should be done with munmap.

Yeah, but it does get called at dri_bo_unmap time... I haven't traced the 
munmap code to see if it would do what we want... if it ends up in vm_close 
too then it would be fine (ref at gtt ioctl time, unref at vm_close time, as 
long as there's not a stray vm_open in there).

Jesse
-- 
Jesse Barnes, Intel Open Source Technology Center
