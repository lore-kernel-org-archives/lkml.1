Return-Path: <linux-kernel-owner+w=401wt.eu-S1757953AbXI2MgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953AbXI2MgW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 08:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755262AbXI2MgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 08:36:15 -0400
Received: from mail.suse.de ([195.135.220.2]:60904 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754697AbXI2MgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 08:36:15 -0400
Date: Sat, 29 Sep 2007 14:36:13 +0200
From: Jan Blunck <jblunck@suse.de>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@lst.de,
       tiwai@suse.de
Subject: Re: [patch] Combine path_put and path_put_conditional
Message-ID: <20070929123613.GU5696@hasse.suse.de>
References: <20070927141200.820970144@X40.localnet> <200709282243.51243.agruen@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709282243.51243.agruen@suse.de>
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG
	Nuernberg)
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, Andreas Gruenbacher wrote:

> The name path_put_conditional (formerly, dput_path) is a little unclear.
> Replace (path_put_conditional + path_put) with path_walk_put_both,
> "put a pair of paths after a path_walk" (see the kerneldoc).

Hmm, I don't know. To put both the nd and path is at the moment only used in
some error paths. I have another series of patches pending which is using
path_put_conditional outside of error paths. So please don't remove
it. Besides that the naming completely hides that the conditional release of
the vfsmount reference. Besides that I would name it path_put_both() just to
make it more "beautiful" wrt the other path_put*() functions.

> @@ -996,8 +1006,8 @@ return_reval:
>  return_base:
>  		return 0;
>  out_dput:
> -		path_put_conditional(&next, nd);
> -		break;
> +		path_walk_put_both(&next, &nd->path);
> +		goto return_err;
>  	}
>  	path_put(&nd->path);
>  return_err:
> @@ -1777,11 +1787,15 @@ ok:
>  	return 0;
>  
>  exit_dput:
> -	path_put_conditional(&path, nd);
> +	path_walk_put_both(&path, &nd->path);
> +	goto exit_intent;
> +
>  exit:
> +	path_put(&nd->path);
> +
> +exit_intent:
>  	if (!IS_ERR(nd->intent.open.file))
>  		release_open_intent(nd);
> -	path_put(&nd->path);
>  	return error;
>  
>  do_link:

IMHO introducing another label just to use it here isn't worth the change.
