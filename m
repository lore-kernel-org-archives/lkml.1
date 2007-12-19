Return-Path: <linux-kernel-owner+w=401wt.eu-S1755715AbXLSSYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715AbXLSSYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 13:24:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753004AbXLSSYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 13:24:15 -0500
Received: from smtp107.sbc.mail.mud.yahoo.com ([68.142.198.206]:40908 "HELO
	smtp107.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751944AbXLSSYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 13:24:15 -0500
X-YMail-OSG: DIHUCPwVM1nms_FOi71srBKyMe8_Yi0und7UmiBcV4oasgX1ZDcSCVKu313dzVRSAVP7y.WvMQ--
Date: Wed, 19 Dec 2007 12:15:22 -0600
From: Michael Halcrow <mike@halcrow.us>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Michael Halcrow <mhalcrow@us.ibm.com>
Subject: Re: [PATCH] ecryptfs: remove debug as mount option, and warn if set via modprobe
Message-ID: <20071219181522.GQ13486@halcrow.us>
Reply-To: Michael Halcrow <mike@halcrow.us>
References: <476959DB.1030507@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476959DB.1030507@redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2007 at 11:50:19AM -0600, Eric Sandeen wrote:
> ecryptfs_debug really should not be a mount option; it is not
> per-mount, but rather sets a global "ecryptfs_verbosity" variable
> which affects all mounted filesysytems.  It's already settable as a
> module load option, I think we can leave it at that.
> 
> Also, if set, since secret values come out in debug messages, kick
> things off with a stern warning.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Makes sense to me.

Acked-by: Mike Halcrow <mhalcrow@us.ibm.com>

> ---
> 
> ndex: linux-2.6.24-rc3/fs/ecryptfs/main.c
> ===================================================================
> --- linux-2.6.24-rc3.orig/fs/ecryptfs/main.c
> +++ linux-2.6.24-rc3/fs/ecryptfs/main.c
> @@ -226,17 +226,15 @@ out:
>  	return rc;
>  }
>  
> -enum { ecryptfs_opt_sig, ecryptfs_opt_ecryptfs_sig, ecryptfs_opt_debug,
> -       ecryptfs_opt_ecryptfs_debug, ecryptfs_opt_cipher,
> -       ecryptfs_opt_ecryptfs_cipher, ecryptfs_opt_ecryptfs_key_bytes,
> +enum { ecryptfs_opt_sig, ecryptfs_opt_ecryptfs_sig,
> +       ecryptfs_opt_cipher, ecryptfs_opt_ecryptfs_cipher,
> +       ecryptfs_opt_ecryptfs_key_bytes,
>         ecryptfs_opt_passthrough, ecryptfs_opt_xattr_metadata,
>         ecryptfs_opt_encrypted_view, ecryptfs_opt_err };
>  
>  static match_table_t tokens = {
>  	{ecryptfs_opt_sig, "sig=%s"},
>  	{ecryptfs_opt_ecryptfs_sig, "ecryptfs_sig=%s"},
> -	{ecryptfs_opt_debug, "debug=%u"},
> -	{ecryptfs_opt_ecryptfs_debug, "ecryptfs_debug=%u"},
>  	{ecryptfs_opt_cipher, "cipher=%s"},
>  	{ecryptfs_opt_ecryptfs_cipher, "ecryptfs_cipher=%s"},
>  	{ecryptfs_opt_ecryptfs_key_bytes, "ecryptfs_key_bytes=%u"},
> @@ -313,7 +311,6 @@ static int ecryptfs_parse_options(struct
>  	substring_t args[MAX_OPT_ARGS];
>  	int token;
>  	char *sig_src;
> -	char *debug_src;
>  	char *cipher_name_dst;
>  	char *cipher_name_src;
>  	char *cipher_key_bytes_src;
> @@ -341,16 +338,6 @@ static int ecryptfs_parse_options(struct
>  			}
>  			sig_set = 1;
>  			break;
> -		case ecryptfs_opt_debug:
> -		case ecryptfs_opt_ecryptfs_debug:
> -			debug_src = args[0].from;
> -			ecryptfs_verbosity =
> -				(int)simple_strtol(debug_src, &debug_src,
> -						   0);
> -			ecryptfs_printk(KERN_DEBUG,
> -					"Verbosity set to [%d]" "\n",
> -					ecryptfs_verbosity);
> -			break;
>  		case ecryptfs_opt_cipher:
>  		case ecryptfs_opt_ecryptfs_cipher:
>  			cipher_name_src = args[0].from;
> @@ -911,6 +898,10 @@ static int __init ecryptfs_init(void)
>  		       "rc = [%d]\n", rc);
>  		goto out_release_messaging;
>  	}
> +	if (ecryptfs_verbosity > 0)
> +		printk(KERN_CRIT "eCryptfs verbosity set to %d. Secret values "
> +			"will be written to the syslog!\n", ecryptfs_verbosity);
> +
>  	goto out;
>  out_release_messaging:
>  	ecryptfs_release_messaging(ecryptfs_transport);
> Index: linux-2.6.24-rc3/fs/ecryptfs/super.c
> ===================================================================
> --- linux-2.6.24-rc3.orig/fs/ecryptfs/super.c
> +++ linux-2.6.24-rc3/fs/ecryptfs/super.c
> @@ -175,10 +175,6 @@ static int ecryptfs_show_options(struct 
>  	}
>  	mutex_unlock(&mount_crypt_stat->global_auth_tok_list_mutex);
>  
> -	/* Note this is global and probably shouldn't be a mount option */
> -	if (ecryptfs_verbosity)
> -		seq_printf(m, ",ecryptfs_debug=%d\n", ecryptfs_verbosity);
> -
>  	seq_printf(m, ",ecryptfs_cipher=%s",
>  		mount_crypt_stat->global_default_cipher_name);
>  
> 
