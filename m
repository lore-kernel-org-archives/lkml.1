Return-Path: <linux-kernel-owner+w=401wt.eu-S1756486AbYCYDxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486AbYCYDxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 23:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753917AbYCYDxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 23:53:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60148 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925AbYCYDxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 23:53:00 -0400
From: Neil Brown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 25 Mar 2008 14:52:46 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18408.30478.519821.624319@notabene.brown>
Cc: Wakko Warner <wakko@animx.eu.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: 2.6.24.3 bug in sysfs with md.
In-Reply-To: message from Andrew Morton on Saturday March 22
References: <20080322222531.GA12182@animx.eu.org>
	<20080322173651.61bff26d.akpm@linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday March 22, akpm@linux-foundation.org wrote:
> On Sat, 22 Mar 2008 18:25:31 -0400 Wakko Warner <wakko@animx.eu.org> wrote:
> 
> > I was poking around with the files laying in /sys/block/md*/md/dev-*/super
> > and found this bug (NOTE: I attempted to read the file 2 times):
> > 
> > [ 5591.212764] ------------[ cut here ]------------
> > [ 5591.212773] kernel BUG at /usr/src/linux/dist/2.6.24.3/fs/sysfs/file.c:126!
> 
> hm, I didn't know 2.6.24 was affected.

$ git describe 8118a859dc7abd873193986c77a8d9bdb877adc8
v2.6.24-rc3-412-g8118a85

Looks like everything since 2.6.24-rc3 is affected.

> 
> Neil, should we backport this?

Yes, I think that would be best.

Thanks,
NeilBrown

> 
> 
> From: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
> To: git-commits-head@vger.kernel.org
> Subject: md: remove the 'super' sysfs attribute from devices in an 'md' array
> Date: 	Thu, 20 Mar 2008 02:59:10 GMT
> Sender: git-commits-head-owner@vger.kernel.org
> 
> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=0e82989d95cc46cc58622381eafa54f7428ee679
> Commit:     0e82989d95cc46cc58622381eafa54f7428ee679
> Parent:     43d8eac44f28d384d2377dcdd1407f51f79dda55
> Author:     NeilBrown <neilb@suse.de>
> AuthorDate: Wed Mar 19 17:00:44 2008 -0700
> Committer:  Linus Torvalds <torvalds@linux-foundation.org>
> CommitDate: Wed Mar 19 18:53:35 2008 -0700
> 
>     md: remove the 'super' sysfs attribute from devices in an 'md' array
>     
>     Exposing the binary blob which is the md 'super-block' via sysfs doesn't
>     really fit with the whole sysfs model, and ever since commit
>     8118a859dc7abd873193986c77a8d9bdb877adc8 ("sysfs: fix off-by-one error
>     in fill_read_buffer()") it doesn't actually work at all (as the size of
>     the blob is often one page).
>     
>     (akpm: as in, fs/sysfs/file.c:fill_read_buffer() goes BUG)
>     
>     So just remove it altogether.  It isn't really useful.
>     
>     Signed-off-by: Neil Brown <neilb@suse.de>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> ---
>  drivers/md/md.c |   12 ------------
>  1 files changed, 0 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index ccbbf63..61ccbd2 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1864,17 +1864,6 @@ static struct rdev_sysfs_entry rdev_state =
>  __ATTR(state, S_IRUGO|S_IWUSR, state_show, state_store);
>  
>  static ssize_t
> -super_show(mdk_rdev_t *rdev, char *page)
> -{
> -	if (rdev->sb_loaded && rdev->sb_size) {
> -		memcpy(page, page_address(rdev->sb_page), rdev->sb_size);
> -		return rdev->sb_size;
> -	} else
> -		return 0;
> -}
> -static struct rdev_sysfs_entry rdev_super = __ATTR_RO(super);
> -
> -static ssize_t
>  errors_show(mdk_rdev_t *rdev, char *page)
>  {
>  	return sprintf(page, "%d\n", atomic_read(&rdev->corrected_errors));
> @@ -2060,7 +2049,6 @@ __ATTR(size, S_IRUGO|S_IWUSR, rdev_size_show, rdev_size_store);
>  
>  static struct attribute *rdev_default_attrs[] = {
>  	&rdev_state.attr,
> -	&rdev_super.attr,
>  	&rdev_errors.attr,
>  	&rdev_slot.attr,
>  	&rdev_offset.attr,
> --
> To unsubscribe from this list: send the line "unsubscribe git-commits-head" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
