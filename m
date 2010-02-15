Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab0BOKLS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 05:11:18 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:48219 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682Ab0BOKLR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 05:11:17 -0500
To: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       "Tejun Heo \<tj\@kernel.org\> Neil Brown" <neilb@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] sysfs: Only take active references on attributes.
References: <m1vde57c11.fsf@fess.ebiederm.org> <4B728CFE.40208@kernel.org>
	<m1sk992bji.fsf@fess.ebiederm.org> <20100210230544.GA678@suse.de>
	<m1ocjwwob1.fsf@fess.ebiederm.org> <4B73671E.2050105@kernel.org>
	<m1bpfvxt67.fsf_-_@fess.ebiederm.org>
	<m14olnxt3s.fsf_-_@fess.ebiederm.org>
	<m1ljezwean.fsf_-_@fess.ebiederm.org>
	<20100215072745.GC12076@hack.private>
	<20100215081527.GD12076@hack.private>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 15 Feb 2010 02:11:11 -0800
In-Reply-To: <20100215081527.GD12076@hack.private> (=?utf-8?Q?=22Am=C3=A9r?=
 =?utf-8?Q?ico?= Wang"'s message of "Mon\, 15 Feb 2010 16\:15\:27 +0800")
Message-ID: <m1ocjqg668.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Américo Wang <xiyou.wangcong@gmail.com> writes:

> On Mon, Feb 15, 2010 at 03:27:45PM +0800, Américo Wang wrote:
>>On Thu, Feb 11, 2010 at 03:20:00PM -0800, Eric W. Biederman wrote:
>>>
>>>If we exclude directories and symlinks from the set of sysfs
>>>dirents where we need active references we are left with
>>>sysfs attributes (binary or not).
>>>
>>>- Tweak sysfs_deactivate to only do something on attributes
>>>- Move lockdep initialization into sysfs_file_add_mode to
>>>  limit it to just attributes.
>>
>>Why?
>>
>>If I read your patch correctly, s_active will be useless
>>for non-attributes sysfs entries? For sysfs dir, maybe,
>>since it can only be removed by sysfs_remove_dir(),
>>but not sure about sysfs symlinks...

Yes. s_active is effectively useless for non-attribute sysfs entries.

> For sysfs dir's, opening it will not get s_active,
> since it doesn't have .open member. But it does
> put s_active when removing it. This seems buggy?

s_active needs to be taken over the lifetime of every method.  For
directories a file descriptor will pin the dirent which does have a
reference to the sysfs dirent, and that ensures the sysfs entry does
not disappear.

There is one common path for removing sysfs dirents and they all call
sysfs_deactivate.  The job of sysfs_deactivate is to wait until there
are no methods actively running so their dirents can have any
non-generic state cleaned up.

Neither symlinks nor directories call sysfs_get/put_active, thus
sysfs_deactivate is effectively a noop for those dirents before my
patch.  After my patch sysfs_deactivate is also a noop from a lockdep
perspective.

Eric
