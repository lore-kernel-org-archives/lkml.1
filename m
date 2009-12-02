Return-Path: <linux-kernel-owner+w=401wt.eu-S1754158AbZLBPog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbZLBPog (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 10:44:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753663AbZLBPof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 10:44:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58851 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002AbZLBPoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 10:44:34 -0500
Date: Wed, 2 Dec 2009 10:42:44 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Divyesh Shah <dpshah@google.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       lizf@cn.fujitsu.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       jmoyer@redhat.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com,
       czoccolo@gmail.com, Alan.Brunelle@hp.com
Subject: Re: [PATCH 05/21] blkio: Introduce the root service tree for cfq
	groups
Message-ID: <20091202154244.GE31715@redhat.com>
References: <1259549968-10369-1-git-send-email-vgoyal@redhat.com> <1259549968-10369-6-git-send-email-vgoyal@redhat.com> <af41c7c40911301555s48553e53o5e9998fe5c160f75@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <af41c7c40911301555s48553e53o5e9998fe5c160f75@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 01, 2009 at 05:25:36AM +0530, Divyesh Shah wrote:
> On Mon, Nov 30, 2009 at 8:29 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > o So far we just had one cfq_group in cfq_data. To create space for more than
> >  one cfq_group, we need to have a service tree of groups where all the groups
> >  can be queued if they have active cfq queues backlogged in these.
> >
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  block/cfq-iosched.c |  136 +++++++++++++++++++++++++++++++++++++++++++++++++-
> >  1 files changed, 133 insertions(+), 3 deletions(-)
> >
> > diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> > index a0d0a83..0a284be 100644
> > --- a/block/cfq-iosched.c
> > +++ b/block/cfq-iosched.c
> > @@ -77,8 +77,9 @@ struct cfq_rb_root {
> >        struct rb_root rb;
> >        struct rb_node *left;
> >        unsigned count;
> > +       u64 min_vdisktime;
> >  };
> > -#define CFQ_RB_ROOT    (struct cfq_rb_root) { RB_ROOT, NULL, 0, }
> > +#define CFQ_RB_ROOT    (struct cfq_rb_root) { RB_ROOT, NULL, 0, 0, }
> >
> >  /*
> >  * Per process-grouping structure
> > @@ -156,6 +157,16 @@ enum wl_type_t {
> >
> >  /* This is per cgroup per device grouping structure */
> >  struct cfq_group {
> > +       /* group service_tree member */
> > +       struct rb_node rb_node;
> > +
> > +       /* group service_tree key */
> > +       u64 vdisktime;
> > +       bool on_st;
> > +
> > +       /* number of cfqq currently on this group */
> > +       int nr_cfqq;
> > +
> >        /*
> >         * rr lists of queues with requests, onle rr for each priority class.
> >         * Counts are embedded in the cfq_rb_root
> > @@ -169,6 +180,8 @@ struct cfq_group {
> >  */
> >  struct cfq_data {
> >        struct request_queue *queue;
> > +       /* Root service tree for cfq_groups */
> > +       struct cfq_rb_root grp_service_tree;
> >        struct cfq_group root_group;
> >
> >        /*
> > @@ -251,6 +264,9 @@ static struct cfq_rb_root *service_tree_for(struct cfq_group *cfqg,
> >                                            enum wl_type_t type,
> >                                            struct cfq_data *cfqd)
> >  {
> > +       if (!cfqg)
> > +               return NULL;
> > +
> >        if (prio == IDLE_WORKLOAD)
> >                return &cfqg->service_tree_idle;
> >
> > @@ -587,6 +603,17 @@ static struct cfq_queue *cfq_rb_first(struct cfq_rb_root *root)
> >        return NULL;
> >  }
> >
> > +static struct cfq_group *cfq_rb_first_group(struct cfq_rb_root *root)
> > +{
> > +       if (!root->left)
> > +               root->left = rb_first(&root->rb);
> > +
> > +       if (root->left)
> > +               return rb_entry(root->left, struct cfq_group, rb_node);
> 
> Can you please define a cfqg_entry macro and reuse that at different
> places in the code?
> #define cfqg_entry(ptr)   rb_entry(ptr, struct cfq_group, rb_node)

Ok, I have introduced rb_entry_cfqg() along the lines of rb_entry_rq().

Changes are there in two patches. Reposting these patches in same thread
soon.

Thanks
Vivek
