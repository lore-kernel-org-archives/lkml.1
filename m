Return-Path: <linux-kernel-owner+w=401wt.eu-S1753455AbYGMGEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455AbYGMGEh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 02:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbYGMGEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 02:04:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51068 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751793AbYGMGEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 02:04:30 -0400
Date: Sat, 12 Jul 2008 22:59:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serue@us.ibm.com>,
       Paul Menage <menage@google.com>, Pavel Emelianov <xemul@openvz.org>
Subject: Re: [PATCH 3/3] devcgroup: code cleanup
Message-Id: <20080712225908.580649fa.akpm@linux-foundation.org>
In-Reply-To: <4872C811.8060608@cn.fujitsu.com>
References: <4872C811.8060608@cn.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Jul 2008 09:51:13 +0800 Li Zefan <lizf@cn.fujitsu.com> wrote:

> @@ -405,11 +404,7 @@ static ssize_t devcgroup_access_write(struct cgroup *cgroup, struct cftype *cft,
>  		wh.major = ~0;
>  		b++;
>  	} else if (isdigit(*b)) {
> -		wh.major = 0;
> -		while (isdigit(*b)) {
> -			wh.major = wh.major*10+(*b-'0');
> -			b++;
> -		}
> +		wh.major = simple_strtoul(b, &b, 0);
>  	} else {
>  		retval = -EINVAL;
>  		goto out2;
> @@ -425,11 +420,7 @@ static ssize_t devcgroup_access_write(struct cgroup *cgroup, struct cftype *cft,
>  		wh.minor = ~0;
>  		b++;
>  	} else if (isdigit(*b)) {
> -		wh.minor = 0;
> -		while (isdigit(*b)) {
> -			wh.minor = wh.minor*10+(*b-'0');
> -			b++;
> -		}
> +		wh.minor = simple_strtoul(b, &b, 0);

This is an interface change.  Previously we only took decimal input. 
Now, we accept decimal or octal or hex, based upon automagic detection.

So scripts which were feeding in "010" will now be setting things to eight,
not to ten.

Methinks we should do this:

--- a/security/device_cgroup.c~devcgroup-code-cleanup-fix
+++ a/security/device_cgroup.c
@@ -394,7 +394,7 @@ static int devcgroup_update_access(struc
 		wh.major = ~0;
 		b++;
 	} else if (isdigit(*b)) {
-		wh.major = simple_strtoul(b, &b, 0);
+		wh.major = simple_strtoul(b, &b, 10);
 	} else {
 		return -EINVAL;
 	}
@@ -407,7 +407,7 @@ static int devcgroup_update_access(struc
 		wh.minor = ~0;
 		b++;
 	} else if (isdigit(*b)) {
-		wh.minor = simple_strtoul(b, &b, 0);
+		wh.minor = simple_strtoul(b, &b, 10);
 	} else {
 		return -EINVAL;
 	}
_

