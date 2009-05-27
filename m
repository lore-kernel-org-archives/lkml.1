Return-Path: <linux-kernel-owner+w=401wt.eu-S1762115AbZE0MLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762115AbZE0MLU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 08:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759312AbZE0MLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 08:11:07 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49642 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758111AbZE0MLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 08:11:05 -0400
Message-ID: <4A1D2DD8.2050709@redhat.com>
Date: Wed, 27 May 2009 15:11:04 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Davide Libenzi <davidel@xmailserver.org>, mtosatti@redhat.com,
       Mark McLoughlin <markmc@redhat.com>
Subject: Re: [KVM PATCH v4 3/3] kvm: add iosignalfd support
References: <20090526191010.20860.75372.stgit@dev.haskins.net> <20090526191539.20860.1385.stgit@dev.haskins.net> <4A1D01F8.8080508@redhat.com> <4A1D285C.9050008@novell.com>
In-Reply-To: <4A1D285C.9050008@novell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
>
>> What happens if you register to iosignalfds for the same address but
>> with different cookies (a very practical scenario)?
>>     
>
> This is really only supported at the iosignal interface level.  Today,
> you can do this and the registration will succeed, but at run-time an
> IO-exit will stop at the first in_range() hit it finds.  Therefore, you
> will only get service on the first/lowest registered range.
>
> I knew this was a limitation of the current io_bus, but I put the
> feature into iosignalfd anyway so that the user/kern interface was
> robust enough to support the notion should we ever need it (and can thus
> patch io_bus at that time).  Perhaps that is short-sighted because
> userspace would never know its ranges weren't really registered properly.
>
> I guess its simple enough to have io_bus check all devices for a match
> instead of stopping on the first.  Should I just make a patch to fix
> this, or should I fix iosignalfd to check for in_range matches and fail
> if it finds overlap?  (We could then add a CAP_OVERLAP_IO bit in the
> future if we finally fix the io_bus capability).  I am inclined to lean
> towards option 2, since its not known whether this will ever be useful,
> and io_bus scanning is in a hot-path.
>
> Thinking about it some more, I wonder if we should just get rid of the
> notion of overlap to begin with.  Its a slippery slope (should we also
> return to userspace after scanning and matching io_bus to see if it has
> any overlap too?).  I am not sure if it would ever be used (real
> hardware doesn't have multiple devices at the same address), and we can
> always have multiple end-points mux from one iosignalfd if we really
> need that.  Thoughts?
>   

Multiple cookies on the same address are required by virtio.  You can't 
mux since the data doesn't go anywhere.

Virtio can survive by checking all rings on a notify, and we can later 
add a mechanism that has a distinct address for each ring, but let's see 
if we can cope with multiple cookies.  Mark?

You could search existing iosignalfds for the same address and re-use 
the same iodevice.  I don't want to search the entire list since that 
precludes tricks like using hashtables or sorting the list by frequency 
of access.

-- 
error compiling committee.c: too many arguments to function

