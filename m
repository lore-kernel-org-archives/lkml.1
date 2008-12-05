Return-Path: <linux-kernel-owner+w=401wt.eu-S1757042AbYLEV4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042AbYLEV4M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 16:56:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756250AbYLEVz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 16:55:59 -0500
Received: from mummy.ncsc.mil ([144.51.88.129]:58162 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755100AbYLEVz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 16:55:58 -0500
Subject: Re: [PATCH (mmotm-2008-12-02-17-08)] Introduce
 security_path_set/clear() hooks.
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: serue@us.ibm.com, jmorris@namei.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, takedakn@nttdata.co.jp,
       haradats@nttdata.co.jp
In-Reply-To: <200812042100.HFE00081.tFFOHMQVOLFOSJ@I-love.SAKURA.ne.jp>
References: <200812021939.FFC05200.OVQJSOMtFFHLFO@I-love.SAKURA.ne.jp>
	 <1228225719.26101.52.camel@moss-spartans.epoch.ncsc.mil>
	 <49364808.1070907@nttdata.co.jp> <493649C5.2060402@nttdata.co.jp>
	 <1228313605.32059.23.camel@moss-spartans.epoch.ncsc.mil>
	 <200812042100.HFE00081.tFFOHMQVOLFOSJ@I-love.SAKURA.ne.jp>
Content-Type: text/plain
Organization: National Security Agency
Date: Fri, 05 Dec 2008 16:53:18 -0500
Message-Id: <1228513998.21715.75.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-12-04 at 21:00 +0900, Tetsuo Handa wrote:
> Hello.
> 
> Stephen Smalley wrote:
> > On Wed, 2008-12-03 at 17:56 +0900, Kentaro Takeda wrote:
> > > Stephen, Serge,
> > > Here is the patch for introducing new security_path_set()/clear() hooks.
> > > 
> > > This patch enables LSM module to remember vfsmount's pathname so that it can 
> > > calculate absolute pathname in security_inode_*(). Since actual MAC can be 
> > > performed after DAC, there will not be any noise in auditing and learning 
> > > features. This patch currently assumes that the vfsmount's pathname is stored in 
> > > hash table in LSM module. (Should I use stack memory?)
> > > 
> > > Since security_inode_*() are not always called after security_path_set(), 
> > > security_path_clear() hook is needed to free the remembered pathname.
> > 
> > Your security_path_set()/security_path_clear() pairs look rather similar
> > to mnt_want_write()/mnt_drop_write() pairs.  What if you were to call
> > your hooks from those functions, and then you would only need to add
> > further hook calls in the case of read-only and execute/search checks?
> 
> Right. Locations of inserting security_path_set()/security_path_clear() pairs
> are subset of mnt_want_write()/mnt_drop_write() pairs. Thus, we can insert
> security_path_set()/security_path_clear() pairs into
> mnt_want_write()/mnt_drop_write() pairs, if we can tolerate performance
> regression. According to our rough measurement, there is about 8 - 22% of
> performance regression. But this approach needs minimum modification to the
> existing kernel (only two hooks to be inserted).

I assume you also need separate hooks to cover the read-only open case?
As for your performance, your implementation of mp_* is clearly
non-optimal, so I'd expect there is plenty of room for improvement
there.

<snip>
> --- linux-2.6.28-rc7-mm1.orig/fs/namespace.c
> +++ linux-2.6.28-rc7-mm1/fs/namespace.c
> @@ -254,6 +254,10 @@ int mnt_want_write(struct vfsmount *mnt)
>  	int ret = 0;
>  	struct mnt_writer *cpu_writer;
>  
> +#ifdef CONFIG_SECURITY_PATH
> +	if (security_path_set(mnt) < 0)
> +		return -ENOMEM;
> +#endif

No #ifdef's within the functions, of course.  That gets handled by
security.h.

-- 
Stephen Smalley
National Security Agency

