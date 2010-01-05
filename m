Return-Path: <linux-kernel-owner+w=401wt.eu-S1755132Ab0AEXAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132Ab0AEXAN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 18:00:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753639Ab0AEXAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 18:00:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54127 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754277Ab0AEXAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 18:00:07 -0500
Date: Tue, 5 Jan 2010 14:59:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Martin Jansa <martin.jansa@gmail.com>
Cc: linux-kernel@vger.kernel.org, Julia Lawall <julia@diku.dk>,
       Martin Jansa <Martin.Jansa@gmail.com>,
       Eric Miao <eric.y.miao@gmail.com>
Subject: Re: [PATCH] pxafb: fix regression from
 d2a34c13e7ccec5d06eafd60e6f80ea531b34668
Message-Id: <20100105145931.a2c46c25.akpm@linux-foundation.org>
In-Reply-To: <1262015683-1711-1-git-send-email-Martin.Jansa@gmail.com>
References: <1262015683-1711-1-git-send-email-Martin.Jansa@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Dec 2009 16:54:43 +0100
Martin Jansa <martin.jansa@gmail.com> wrote:

> fbi->dev->platform_data is void * and gcc does not allow to access
> !fbi->dev->platform_data->smart_update without cast platform_data to
> (struct pxafb_mach_info) or assignment as used in this patch.
> 
> Signed-off-by: Martin Jansa <Martin.Jansa@gmail.com>
> ---
>  drivers/video/pxafb.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/video/pxafb.c b/drivers/video/pxafb.c
> index 415858b..241468c 100644
> --- a/drivers/video/pxafb.c
> +++ b/drivers/video/pxafb.c
> @@ -1223,12 +1223,17 @@ static int pxafb_smart_thread(void *arg)
>  	struct pxafb_info *fbi = arg;
>  	struct pxafb_mach_info *inf;
>  
> -	if (!fbi || !fbi->dev->platform_data->smart_update) {
> +	if (!fbi) {
>  		pr_err("%s: not properly initialized, thread terminated\n",
>  				__func__);
>  		return -EINVAL;
>  	}
>  	inf = fbi->dev->platform_data;
> +	if (!inf || !inf->smart_update) {
> +		pr_err("%s: not properly initialized, thread terminated\n",
> +				__func__);
> +		return -EINVAL;
> +	}
>  
>  	pr_debug("%s(): task starting\n", __func__);
>  

This got fixed differently in Eric's tree.  The patch is still in
linux-next, not mainline:

: commit da2c3f0ead336c04b4d1ad36ff42d8d264f44f65
: Author:     Eric Miao <eric.y.miao@gmail.com>
: AuthorDate: Sat Dec 26 16:25:18 2009 +0800
: Commit:     Eric Miao <eric.y.miao@gmail.com>
: CommitDate: Tue Dec 29 14:11:27 2009 +0800
: 
:     [ARM] pxafb: fix building issue of incorrect reference
:     
:     Commit "d2a34c1 drivers/video: Move dereference after NULL test" introduced
:     a build error of "fbi->dev->platform_data->smart_update" being unknown type
:     to the compiler, fix this by removing the unnecessary test of 'fbi'.
:     
:     Cc: Julia Lawall <julia@diku.dk>
:     Signed-off-by: Eric Miao <eric.y.miao@gmail.com>
: 
: diff --git a/drivers/video/pxafb.c b/drivers/video/pxafb.c
: index 415858b..825b665 100644
: --- a/drivers/video/pxafb.c
: +++ b/drivers/video/pxafb.c
: @@ -1221,9 +1221,9 @@ static void setup_smart_timing(struct pxafb_info *fbi,
:  static int pxafb_smart_thread(void *arg)
:  {
:  	struct pxafb_info *fbi = arg;
: -	struct pxafb_mach_info *inf;
: +	struct pxafb_mach_info *inf = fbi->dev->platform_data;
:  
: -	if (!fbi || !fbi->dev->platform_data->smart_update) {
: +	if (!inf->smart_update) {
:  		pr_err("%s: not properly initialized, thread terminated\n",
:  				__func__);
:  		return -EINVAL;
: 

That patch fixes the build, but it also eliminates the test for
fbi==NULL.  The changelog doesn't explain that change and I wonder if
it was intentional and correct?

