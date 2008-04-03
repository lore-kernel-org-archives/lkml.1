Return-Path: <linux-kernel-owner+w=401wt.eu-S1755207AbYDCE4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbYDCE4l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 00:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750960AbYDCE4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 00:56:32 -0400
Received: from smtp118.sbc.mail.re3.yahoo.com ([66.196.96.91]:29465 "HELO
	smtp118.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750949AbYDCE4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 00:56:31 -0400
X-YMail-OSG: E2qSHQsVM1l64yhjNMfyOt9322woUVnINh0Hxctk0MC6i96EqXFx8Vh2vGREo56twjxV7brM0TUyP4k2Zlc4IcccHxHQqLp7KvHsQW1.UIxLuCqi917HaupOGi69gT3d5y4ANeGoLU7iNqI-
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 2 Apr 2008 23:53:03 -0500
From: serge@hallyn.com
To: Paul Menage <menage@google.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] cgroups: introduce cft->read_seq()
Message-ID: <20080403045303.GA15590@vino.hallyn.com>
References: <20080403010130.GA20543@sergelap.austin.ibm.com> <6599ad830804022136o24be5797s20843e18c91aeaf0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830804022136o24be5797s20843e18c91aeaf0@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Paul Menage (menage@google.com):
> On Wed, Apr 2, 2008 at 6:01 PM, Serge E. Hallyn <serue@us.ibm.com> wrote:
> >  +       /*
> >  +        * read_seq() is used for outputting a simple sequence
> >  +        * using seqfile.
> >  +        */
> >  +       int (*read_seq) (struct cgroup *cont, struct cftype *cft,
> >  +                        struct seq_file *m);
> 
> Maybe make it read_seq_string() to emphasise that it's not intended
> for structured data?
> 
> >
> >  -static int cgroup_seqfile_show(struct seq_file *m, void *arg)
> >  +static int cgroup_map_seqfile_show(struct seq_file *m, void *arg)
> >   {
> >         struct cgroup_seqfile_state *state = m->private;
> >         struct cftype *cft = state->cft;
> >  @@ -1529,6 +1529,13 @@ static int cgroup_seqfile_show(struct seq_file *m, void *arg)
> >         return cft->read_map(state->cgroup, cft, &cb);
> >   }
> 
> I think you can make this simpler - have cgroup_seqfile_show() switch
> based on whether the cft has a read_seq_string or a read_map, and then
> you only need one function.
> 
> >
> >  +static int cgroup_simple_seqfile_show(struct seq_file *m, void *arg)
> >  +{
> >  +       struct cgroup_seqfile_state *state = m->private;
> >  +       struct cftype *cft = state->cft;
> >  +       return cft->read_seq(state->cgroup, cft, m);
> >  +}
> >  +
> >   int cgroup_seqfile_release(struct inode *inode, struct file *file)
> >   {
> >         struct seq_file *seq = file->private_data;
> >  @@ -1562,7 +1569,18 @@ static int cgroup_file_open(struct inode *inode, struct file *file)
> >                 state->cft = cft;
> >                 state->cgroup = __d_cgrp(file->f_dentry->d_parent);
> >                 file->f_op = &cgroup_seqfile_operations;
> >  -               err = single_open(file, cgroup_seqfile_show, state);
> >  +               err = single_open(file, cgroup_map_seqfile_show, state);
> >  +               if (err < 0)
> >  +                       kfree(state);
> >  +       } else if (cft->read_seq) {
> >  +               struct cgroup_seqfile_state *state =
> >  +                       kzalloc(sizeof(*state), GFP_USER);
> >  +               if (!state)
> >  +                       return -ENOMEM;
> >  +               state->cft = cft;
> >  +               state->cgroup = __d_cgrp(file->f_dentry->d_parent);
> >  +               file->f_op = &cgroup_seqfile_operations;
> >  +               err = single_open(file, cgroup_simple_seqfile_show, state);
> >                 if (err < 0)
> >                         kfree(state);
> 
> and this arm can just be eliminated, by adding "||
> cft->read_seq_string" to the test for cft_read_seq_map above.
> 
> It was always my intention that cgroup_seqfile_show() be able to
> handle multiple data types, but up until now we only had one.

Thanks Paul, will do each of these.

-serge
