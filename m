Return-Path: <linux-kernel-owner+w=401wt.eu-S1751930AbYJYUrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930AbYJYUrP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 16:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751091AbYJYUq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 16:46:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49224 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751040AbYJYUq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 16:46:57 -0400
Date: Sat, 25 Oct 2008 13:46:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Antonino Daplas <adaplas@gmail.com>,
       Krzysztof Helt <krzysztof.h1@wp.pl>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH RESEND] vgacon: remember scrollback buffer on console
 switch
Message-Id: <20081025134615.36f7285f.akpm@linux-foundation.org>
In-Reply-To: <20081025195814.GD10932@joi>
References: <20081025195814.GD10932@joi>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Oct 2008 21:58:19 +0200 Marcin Slusarz <marcin.slusarz@gmail.com> wrote:

> Add support for persistent console history, surviving
> console switches. It allocates new scrollback buffer only when
> user switches console for the first time.
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Antonino Daplas <adaplas@gmail.com>
> Cc: Krzysztof Helt <krzysztof.h1@wp.pl>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: linux-fbdev-devel@lists.sourceforge.net
> ---
>  drivers/video/console/Kconfig  |   11 ++++++
>  drivers/video/console/vgacon.c |   75 +++++++++++++++++++++++++++++++++++++--
>  2 files changed, 82 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/video/console/Kconfig b/drivers/video/console/Kconfig
> index 2f50a80..09e3d98 100644
> --- a/drivers/video/console/Kconfig
> +++ b/drivers/video/console/Kconfig
> @@ -43,6 +43,17 @@ config VGACON_SOFT_SCROLLBACK_SIZE
>  	 buffer.  Each 64KB will give you approximately 16 80x25
>  	 screenfuls of scrollback buffer
>  
> +config VGACON_REMEMBER_SCROLLBACK
> +	bool "Remember scrollback buffer on console switch"
> +	depends on VGACON_SOFT_SCROLLBACK
> +	default y
> +	help
> +	 Say 'Y' here if you want the scrollback buffer to be remembered
> +	 on console switch and restored when you switch back.
> +
> +	 Note: every VGA console will use its own buffer, but it will be
> +	 allocated only when you switch to this console for the first time.

I'd question the value in adding the config option.  Why not make the
feature unconditionally present?

>  
> +#define SCROLLBACK_SIZE (CONFIG_VGACON_SOFT_SCROLLBACK_SIZE * 1024)
> +
> ...
>
> +#ifdef CONFIG_VGACON_REMEMBER_SCROLLBACK
> +static struct vgacon_scrollback_info {
> +	void *data;
> +	int cnt;
> +	int tail;
> +	int cur;
> +	int rows;
> +	int size;
> +} vgacon_scrollbacks[MAX_NR_CONSOLES];

Perhaps you were concerned about memory consumption?

If so, it would be much much better to make this feature switchable at
runtime (module parameter/boot option or a /proc or /sys knob).

> +static int vgacon_last_vc_num;

We have lots of global state here with no apparent locking protecting
it.  Possibly there's some higher-level lock which provides
seralisation?  If so, the addition of a comment explaining all
this would be good.

