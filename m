Return-Path: <linux-kernel-owner+w=401wt.eu-S1752161AbXLCXUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161AbXLCXUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 18:20:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751267AbXLCXUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 18:20:38 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:41009 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbXLCXUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 18:20:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=k+vXsgQEnUZOnkqrJPQm3B+hhKOox8/plQm28UHrzC2PxJuO5XjqCZpmbKebJaqXUdemqAl+I785gnZCd6Vue9MmVW/IZPdxX9KXuutK3saYn/RzPagGq/sZCZvg7uzl3Qy8SliZ52VUaDXCjkQTXhjE5qrzoM0lQ0qecbg/PEo=
Message-ID: <47548F40.8090309@gmail.com>
Date: Tue, 04 Dec 2007 00:20:32 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: casey@schaufler-ca.com
CC: akpm@osdl.org, torvalds@osdl.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] (2.6.24-rc3-mm2) -mm Smack mutex cleanup
References: <47544D58.5090306@schaufler-ca.com>
In-Reply-To: <47544D58.5090306@schaufler-ca.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2007 07:39 PM, Casey Schaufler wrote:
> From: Casey Schaufler <casey@schaufler-ca.com>
> 
> Clean out unnecessary mutex initializations for Smack list locks.
> Once this is done, there is no need for them to be shared among
> multiple files, so pull them out of the header file and put them
> in the files where they belong.

Then it might be static.

> Pull unnecessary locking from smack_inode_setsecurity, it used
> to be required when the assignment was not guaranteed to be a
> scalar value but isn't now.
> 
> Change uses of __capable(current,...) to capable(...).
> Take out an inappropriate cast. Use container_of() instead
> of doing the same calculation by hand.
> Fix comment spelling errors.

Too many different changes according to the name of the patch.

> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> 
> ---
> 
> Tested with stamp-2007-11-30-16-39
> 
>  security/smack/smack.h        |    3 --
>  security/smack/smack_access.c |    3 ++
>  security/smack/smack_lsm.c    |   34 +++++++++-----------------------
>  security/smack/smackfs.c      |    6 +++++
>  4 files changed, 19 insertions(+), 27 deletions(-)
> 
> diff -uprN -X linux-2.6.24-rc3-mm2-base/Documentation/dontdiff linux-2.6.24-rc3-mm2-base/security/smack/smack_lsm.c linux-2.6.24-rc3-mm2-smack/security/smack/smack_lsm.c
> --- linux-2.6.24-rc3-mm2-base/security/smack/smack_lsm.c	2007-11-27 16:47:05.000000000 -0800
> +++ linux-2.6.24-rc3-mm2-smack/security/smack/smack_lsm.c	2007-11-28 11:46:13.000000000 -0800
[...]
> @@ -748,9 +746,7 @@ static int smack_inode_setsecurity(struc
>  		return -EINVAL;
>  
>  	if (strcmp(name, XATTR_SMACK_SUFFIX) == 0) {
> -		mutex_lock(&nsp->smk_lock);
>  		nsp->smk_inode = sp;
> -		mutex_unlock(&nsp->smk_lock);
>  		return 0;
>  	}
>  	/*

Ok, it still might be atomic as a variable change, but it will break scenarios
such as

mutex_lock(&nsp->smk_lock);
create(nsp->smk_inode);
cook_a_dinner();
get_info(nsp->smk_inode);
mutex_unlock(&nsp->smk_lock);

While cook_a_dinner(), smack_inode_setsecurity() is called and the attribute
changed...

Doesn't this matter?
