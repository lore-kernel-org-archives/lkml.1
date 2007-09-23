Return-Path: <linux-kernel-owner+w=401wt.eu-S1756025AbXIWWNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025AbXIWWNl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 18:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050AbXIWWNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 18:13:33 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:54353 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbXIWWNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 18:13:32 -0400
Message-ID: <46F6E502.9000101@tiscali.nl>
Date: Mon, 24 Sep 2007 00:13:22 +0200
From: roel <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: WANG Cong <xiyou.wangcong@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       marcel@holtmann.org, bluez-devel@lists.sourceforge.net,
       maxk@qualcomm.com
Subject: Re: [-mm Patch] net/bluetooth/hidp/core.c: Make hidp_setup_input()
 return int
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <20070923030105.GH2475@hacking>
In-Reply-To: <20070923030105.GH2475@hacking>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

WANG Cong wrote:
> This patch does the following things:
> 
> - Make hidp_setup_input() return int to indicate errors.
> - Check its return value to handle errors.
> 
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> 
> ---
>  net/bluetooth/hidp/core.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6.23-rc6-mm1/net/bluetooth/hidp/core.c
> ===================================================================
> --- linux-2.6.23-rc6-mm1.orig/net/bluetooth/hidp/core.c
> +++ linux-2.6.23-rc6-mm1/net/bluetooth/hidp/core.c
> @@ -625,7 +625,7 @@ static struct device *hidp_get_device(st
>  	return conn ? &conn->dev : NULL;
>  }
>  
> -static inline void hidp_setup_input(struct hidp_session *session, struct hidp_connadd_req *req)
> +static inline int hidp_setup_input(struct hidp_session *session, struct hidp_connadd_req *req)
>  {
>  	struct input_dev *input = session->input;
>  	int i;
> @@ -669,7 +669,7 @@ static inline void hidp_setup_input(stru
>  
>  	input->event = hidp_input_event;
>  
> -	input_register_device(input);
> +	return input_register_device(input);
>  }
>  
>  static int hidp_open(struct hid_device *hid)
> @@ -823,7 +823,8 @@ int hidp_add_connection(struct hidp_conn
>  	session->idle_to = req->idle_to;
>  
>  	if (session->input)
> -		hidp_setup_input(session, req);
> +		if ((err = (hidp_setup_input(session, req))))
> +			goto failed;

This is confusing, why not just do

	if (session->input) {
		err = hidp_setup_input(session, req);
		if (err)
			goto failed;
	}

>  
>  	if (session->hid)
>  		hidp_setup_hid(session, req);
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

