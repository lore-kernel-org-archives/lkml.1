Return-Path: <linux-kernel-owner+w=401wt.eu-S1754891AbYJHKJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891AbYJHKJ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 06:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753231AbYJHKJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 06:09:20 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:23053 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170AbYJHKJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 06:09:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=rUzKsZTuHj3a1AtBmZ1InEcbMDArehjDVz3szX/Iq2fxEvDTNNAas9VTdD1C1fLTWU
         l+TfZgweoOHmHjqJ/1rfRWkB6J96ED0ra0eLTnvhV865ms07Fe4d3VETiyh5SWbYSIxj
         lTq6ceBh3HnRxppb+/wFHBk3dYPE1IoOQYboo=
Message-ID: <7c86c4470810080309yffd7994le912950e569b3d1b@mail.gmail.com>
Date: Wed, 8 Oct 2008 12:09:16 +0200
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "David Gibson" <david@gibson.dropbear.id.au>, eranian@gmail.com,
       linux-kernel@vger.kernel.org,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: Re: perfmon3 interface overview
In-Reply-To: <20081008005356.GA13615@yookeroo.seuss>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7c86c4470809231432j4231cfa4g7dd158a7fe9c9277@mail.gmail.com>
	 <7c86c4470809251448j65fb99f1nfdb3980e0716149a@mail.gmail.com>
	 <20081003061713.GL3002@yookeroo.seuss>
	 <7c86c4470810030354x6984372akfe18761da7504a0c@mail.gmail.com>
	 <7c86c4470810030358m1a0fdcc5i5512a1c2a6696457@mail.gmail.com>
	 <20081005055339.GC469@yookeroo.seuss>
	 <7c86c4470810051423v2116193vc2e1b67ce480488d@mail.gmail.com>
	 <20081007035616.GB19037@yookeroo.seuss>
	 <7c86c4470810070246x7ab8cc32k82177c7fdcf72b3f@mail.gmail.com>
	 <20081008005356.GA13615@yookeroo.seuss>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,


On Wed, Oct 8, 2008 at 2:53 AM, David Gibson
<david@gibson.dropbear.id.au> wrote:
David,

>> >>     int pfm_control_sets(int fd, uint64_t flags, void *sets, size_t
>> >>     sz);
>> >
>> > Hrm.  This now has identical signature to the {read,write}_pmrs.  I
>> > wonder if these could be sensibly combined.  Maybe have
>> > pfm_get_info(), pfm_set_info() which can get/set control structures
>> > for several different namespaces: PMCs PMDs and now event sets.
>> >
>> I think this would be too generic as it would be mixing very different
>> data types. This is not the case for pfm_write_pmrs() and pfm_read_pmrs()
>> because you are always passing 'register descriptions'.
>>
>> There is a fundamental difference between pfm_control_sets() and
>> pfm_write_pmrs()/pfm_read_pmrs(). For the latter, the 'action' is hardcoded
>> in the name of the syscall, i.e., read or write, what varies is whether or not
>> we are passing PMD or PMC. For the former, the 'action', i.e., create new
>> set or get info about a set, is hardcoded in the flags, and it determines the
>
> Uh.. I was assuming if combined we'd drop the selecting flag from
> control_sets() and instead make the pfm_read_stuff() call be the
> get_info() equivalent when used on the eventsets space and
> pfm_write_stuff() be the create/modify sets call.
>
There is something I'd like o clarify about event sets. People may be
wondering why we need a separate call to create new event sets. Why
not create the sets when the session is created, e.g., 'create a
session with 5 sets'.

There are several reasons for not doing this. Each set has some attributes which
describes how and when to switch to another set. Switching can be done based
on timeout or based on the number of overflows of counters, each chosen on a
per set basis, i.e,, it is possible to combine overflow and timeout switching.
Furthermore, the timeout is defined per set and can thus vary from one
set to the
other. Overflow switching is controlled by a threshold passed as an
attribute to the
PMD registers.

If we were to create sets with the sessions, it would be more than a matter of
passing the number of sets. We would actually have to pass the set attributes
(pfarg_set_desc_t) and a size parameter.

We could do this in v3.0 but it would have to work incrementally as initially we
won't support event sets in mainline. The call would look as follows:

int pfm_create_session(int flags, pfarg_sinfo_t *sif);
int pfm_create_session(int flags, pfarg_sinfo_t *sif, char *smpl_name,
void *smpl_arg, size_t arg_size);
int pfm_create_session(int flags, pfarg_sinfo_t *sif, char *smpl_name,
void *smpl_arg, size_t arg_size, pfarg_set_desc_t *s, size_t sz);

I think this call is a bit too complicated. It does a lot of things.
Furthermore, you lose the ability to add sets on the fly. Deleting may
be possible via another call.

So my inclination is to keep this as a separate call. By default, one
set is created (set0), with no switching attribute. It is possible
to change the attributes by recreating the set. That means, unless you
need more sets, you have nothing to do.


> The fact that the structure is different for read/write in this case
> is a bit funny.  In fact it would probably be best to have different
> 'type' fields for read and write too (EVTSET_INFOm only usable for
> reads , and EVTSET_CONTROL only for writes, maybe).
>
>
> I'm not dead-set on combining these calls, but it seems to me we've
> already just about made the read/write calls into a read/write array
> of control structures in some namespace call, which pretty much is
> what the event set call is too.
>
I see, you are pushing it a bit further here. If I understand, you're saying:

int pfm_read_session(int fd, int flags, int type, void *t, size_t sz);
int pfm_write_session(int fd, int flags, int type, void *t, size_t sz);

Where type could be:
   PFM_RWFL_PMD           : write simplified pmds registers (pfarg_pmr_t)
   PFM_RWFL_PMD_ATTR: read or write pmds registers with extended attributes.
   PFM_RWFL_PMC           : write pmcs register (pfarg_pmr_t), note:
this is for writing only.
   PFM_RWFL_SETINFO    : read set information (pfarg_set_info_t). Only
supported by pfm_read_session
   PFM_RWFL_CREATSET: create new event sets (pfarg_set_desc_t). Only
supported by pfm_write_session

I am a bit worried this is too generic, especially for creating sets.
Yet it offers the advantage of being
very compact and extensible. I'd like to combine pfarg_set_info_t and
pfarg_set_desc_t if possible, even
if some fields are used in only one of the calls.

In summary, here is the current proposal:

   int pfm_create_session(int flags, pfarg_sinfo_t *sif,
                                         [char *smpl_name,
                                          void *smpl_arg,
                                          size_t arg_sz]);

  int pfm_read_session(int fd, int flags, int type, void *t, size_t sz);

  int pfm_write_session(int fd, int flags, int type, void *t, size_t sz);

  int pfm_attach_session((int fd, int flags, int target); /* target =
-1 for detach */

  int pfm_set_state_session(int fd, int flags);

  No other calls are necessary to support event sets and multiplexing.
