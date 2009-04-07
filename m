Return-Path: <linux-kernel-owner+w=401wt.eu-S1753756AbZDGGDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756AbZDGGDx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 02:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750945AbZDGGDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 02:03:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33002 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820AbZDGGDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 02:03:43 -0400
Date: Tue, 7 Apr 2009 08:03:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Avan Anishchuk <matimatik@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [patch] ramfs: add support for "mode=" mount option, fix
Message-ID: <20090407060309.GA21788@elte.hu>
References: <20090405193944.GA12691@elte.hu> <alpine.LFD.2.00.0904061842490.4010@localhost.localdomain> <alpine.LFD.2.00.0904062045530.4010@localhost.localdomain> <alpine.LFD.2.00.0904062108550.4010@localhost.localdomain> <alpine.LFD.2.00.0904062142110.4010@localhost.localdomain> <20090407052801.GA4235@elte.hu> <20090407055502.GA22881@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090407055502.GA22881@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Wu Fengguang <fengguang.wu@intel.com> wrote:

> On Tue, Apr 07, 2009 at 01:28:01PM +0800, Ingo Molnar wrote:
> > 
> > * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > 
> > > On Mon, 6 Apr 2009, Linus Torvalds wrote:
> > > > 
> > > > It bisected past them. I'm getting worried that it's timing-related, 
> > > > because nothing that remains looks even remotely interesting for that Mac 
> > > > mini, but right now:
> > > > 
> > > >  - bad: 56fcef75117a153f298b3fe54af31053f53997dd
> > > >  - good: bb233fdfc7b7cefe45bfa2e8d1b24e79c60a48e5
> > > > 
> > > > and there's not a whole lot of commits in between.
> > > 
> > > It's c3b1b1cbf002e65a3cabd479e68b5f35886a26db: 'ramfs: add support 
> > > for "mode=" mount option'.
> > > 
> > > And I checked. Reverting it at the tip fixes it. So no random 
> > > timing fluctuations.
> > > 
> > > So that commit causes some random SLAB corruption, that then 
> > > (depending apparently on luck) may or may not crash in some odd 
> > > random places later.
> > 
> > ah - forget my previous mail then.
> > 
> > This commit does have a couple of genuinely odd looking lines.
> > 
> > For example:
> > 
> > +       sb->s_fs_info = fsi;
> > +
> > +       err = ramfs_parse_options(data, &fsi->mount_opts);
> > +       if (err)
> > +               goto fail;
> > 
> > Say we fail in ramfs_parse_options() and do the 'fail' pattern:
> > 
> > +fail:
> > +       kfree(fsi);
> > +       iput(inode);
> > +       return err;
> > 
> > so we have 'fsi' kfree()'d but dont clear sb->s_fs_info! That's 
> > almost always a bad practice. And indeed, in the kill_super 
> 
> Sorry - yes, the double kfree() shall be the root cause!
> 
> get_sb_nodev() calls kill_sb() after a failed fill_super():
> 
>         error = fill_super(s, data, flags & MS_SILENT ? 1 : 0);
>         if (error) {
>                 up_write(&s->s_umount);
>                 deactivate_super(s);
>                 return error;
>         }
> 
> > callback:
> > 
> > +static void ramfs_kill_sb(struct super_block *sb)
> > +{
> > +       kfree(sb->s_fs_info);
> > 
> > What ensures that this cannot be a double kfree() memory corruption? 
> > That pointer should have been cleared with something like the patch 
> > below. (totally untested)
> > 
> > And there's also another, probably just theoretical worry about 
> > another failure path:
> > 
> > +       fsi = kzalloc(sizeof(struct ramfs_fs_info), GFP_KERNEL);
> > +       if (!fsi) {
> > +               err = -ENOMEM;
> > +               goto fail;
> > +       }
> > +       sb->s_fs_info = fsi;
> > 
> > leaves sb->s_fs_info uninitialized in the failure case, and might 
> > hit this code unconditionally:
> > 
> > +static void ramfs_kill_sb(struct super_block *sb)
> > +{
> > +       kfree(sb->s_fs_info);
> > +       kill_litter_super(sb);
> > +}
> > 
> > Leaving this code at the mercy of the external call environment 
> > initializing sb->s_fs_info. Which if it does not do (or stops 
> > doing in the future), can trigger a kfree of a random pointer.
> > 
> > (I think ->kill_super() gets called even if ->fill_super() fails, 
> > but i have not checked closely.)
> 
> You are right, see above.
> 
> > These kinds of assymetric failure paths are really a red flag during 
> > review.
> > 
> > VFS infrastructure nit: we have 20 other similar looking but 
> > slightly differently implemented filesystem options parsers, in each 
> > filesystem. Might make sense to factor that out a bit and 
> > standardize it across all filesystems and make it all a bit safer. 
> > Duplicating code like that is never good IMHO.
> > 
> > 	Ingo
> > 
> 
> Acked-by: Wu Fengguang <fengguang.wu@intel.com>
> 
> The patch looks pretty good and runs OK here.

ok, good - i didnt even build it - you can add my signoff too:

  Signed-off-by: Ingo Molnar <mingo@elte.hu>

Thanks,

	Ingo
