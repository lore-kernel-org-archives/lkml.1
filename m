Return-Path: <linux-kernel-owner+w=401wt.eu-S1759498AbYGPVih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759498AbYGPVih (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 17:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757322AbYGPVi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 17:38:28 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33297 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757345AbYGPVi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 17:38:26 -0400
Date: Wed, 16 Jul 2008 22:38:01 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: David Teigland <teigland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dlm: sparse endian annotations
Message-ID: <20080716213801.GK28946@ZenIV.linux.org.uk>
References: <1216239367.28841.22.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216239367.28841.22.camel@brick>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 01:16:07PM -0700, Harvey Harrison wrote:


NAK on ones below.  You are only hiding the warnings; ...s() is not making
it any better.


>  static void header_out(struct dlm_header *hd)
>  {
> -	hd->h_version		= cpu_to_le32(hd->h_version);
> -	hd->h_lockspace		= cpu_to_le32(hd->h_lockspace);
> -	hd->h_nodeid		= cpu_to_le32(hd->h_nodeid);
> -	hd->h_length		= cpu_to_le16(hd->h_length);
> +	cpu_to_le32s(&hd->h_version);
> +	cpu_to_le32s(&hd->h_lockspace);
> +	cpu_to_le32s(&hd->h_nodeid);
> +	cpu_to_le16s(&hd->h_length);
>  }
>  
>  static void header_in(struct dlm_header *hd)
>  {
> -	hd->h_version		= le32_to_cpu(hd->h_version);
> -	hd->h_lockspace		= le32_to_cpu(hd->h_lockspace);
> -	hd->h_nodeid		= le32_to_cpu(hd->h_nodeid);
> -	hd->h_length		= le16_to_cpu(hd->h_length);
> +	le32_to_cpus(&hd->h_version);
> +	le32_to_cpus(&hd->h_lockspace);
> +	le32_to_cpus(&hd->h_nodeid);
> +	le16_to_cpus(&hd->h_length);
>  }
>  
>  /* higher errno values are inconsistent across architectures, so select
>     one set of values for on the wire */

> -static int to_dlm_errno(int err)
> +static void to_dlm_errno(int *err)
>  {
> -	switch (err) {
> +	switch (*err) {
>  	case -EDEADLK:
> -		return -DLM_ERRNO_EDEADLK;
> +		*err = -DLM_ERRNO_EDEADLK;
>  	case -EBADR:
> -		return -DLM_ERRNO_EBADR;
> +		*err = -DLM_ERRNO_EBADR;
>  	case -EBADSLT:
> -		return -DLM_ERRNO_EBADSLT;
> +		*err = -DLM_ERRNO_EBADSLT;
>  	case -EPROTO:
> -		return -DLM_ERRNO_EPROTO;
> +		*err = -DLM_ERRNO_EPROTO;
>  	case -EOPNOTSUPP:
> -		return -DLM_ERRNO_EOPNOTSUPP;
> +		*err = -DLM_ERRNO_EOPNOTSUPP;
>  	case -ETIMEDOUT:
> -		return -DLM_ERRNO_ETIMEDOUT;
> +		*err = -DLM_ERRNO_ETIMEDOUT;
>  	case -EINPROGRESS:
> -		return -DLM_ERRNO_EINPROGRESS;
> +		*err = -DLM_ERRNO_EINPROGRESS;
>  	}
> -	return err;
> +	cpu_to_le32s(err);
>  }
  
> -static int from_dlm_errno(int err)
> +static void from_dlm_errno(int *err)
>  {
> -	switch (err) {
> +	le32_to_cpus(err);
> +	switch (*err) {
>  	case -DLM_ERRNO_EDEADLK:
> -		return -EDEADLK;
> +		*err = -EDEADLK;
>  	case -DLM_ERRNO_EBADR:
> -		return -EBADR;
> +		*err = -EBADR;
>  	case -DLM_ERRNO_EBADSLT:
> -		return -EBADSLT;
> +		*err = -EBADSLT;
>  	case -DLM_ERRNO_EPROTO:
> -		return -EPROTO;
> +		*err = -EPROTO;
>  	case -DLM_ERRNO_EOPNOTSUPP:
> -		return -EOPNOTSUPP;
> +		*err = -EOPNOTSUPP;
>  	case -DLM_ERRNO_ETIMEDOUT:
> -		return -ETIMEDOUT;
> +		*err = -ETIMEDOUT;
>  	case -DLM_ERRNO_EINPROGRESS:
> -		return -EINPROGRESS;
> +		*err = -EINPROGRESS;
>  	}
> -	return err;
>  }
>  
>  void dlm_message_out(struct dlm_message *ms)
>  {
>  	header_out(&ms->m_header);
>  
> -	ms->m_type		= cpu_to_le32(ms->m_type);
> -	ms->m_nodeid		= cpu_to_le32(ms->m_nodeid);
> -	ms->m_pid		= cpu_to_le32(ms->m_pid);
> -	ms->m_lkid		= cpu_to_le32(ms->m_lkid);
> -	ms->m_remid		= cpu_to_le32(ms->m_remid);
> -	ms->m_parent_lkid	= cpu_to_le32(ms->m_parent_lkid);
> -	ms->m_parent_remid	= cpu_to_le32(ms->m_parent_remid);
> -	ms->m_exflags		= cpu_to_le32(ms->m_exflags);
> -	ms->m_sbflags		= cpu_to_le32(ms->m_sbflags);
> -	ms->m_flags		= cpu_to_le32(ms->m_flags);
> -	ms->m_lvbseq		= cpu_to_le32(ms->m_lvbseq);
> -	ms->m_hash		= cpu_to_le32(ms->m_hash);
> -	ms->m_status		= cpu_to_le32(ms->m_status);
> -	ms->m_grmode		= cpu_to_le32(ms->m_grmode);
> -	ms->m_rqmode		= cpu_to_le32(ms->m_rqmode);
> -	ms->m_bastmode		= cpu_to_le32(ms->m_bastmode);
> -	ms->m_asts		= cpu_to_le32(ms->m_asts);
> -	ms->m_result		= cpu_to_le32(to_dlm_errno(ms->m_result));
> +	cpu_to_le32s(&ms->m_type);
> +	cpu_to_le32s(&ms->m_nodeid);
> +	cpu_to_le32s(&ms->m_pid);
> +	cpu_to_le32s(&ms->m_lkid);
> +	cpu_to_le32s(&ms->m_remid);
> +	cpu_to_le32s(&ms->m_parent_lkid);
> +	cpu_to_le32s(&ms->m_parent_remid);
> +	cpu_to_le32s(&ms->m_exflags);
> +	cpu_to_le32s(&ms->m_sbflags);
> +	cpu_to_le32s(&ms->m_flags);
> +	cpu_to_le32s(&ms->m_lvbseq);
> +	cpu_to_le32s(&ms->m_hash);
> +	cpu_to_le32s(&ms->m_status);
> +	cpu_to_le32s(&ms->m_grmode);
> +	cpu_to_le32s(&ms->m_rqmode);
> +	cpu_to_le32s(&ms->m_bastmode);
> +	cpu_to_le32s(&ms->m_asts);
> +	to_dlm_errno(&ms->m_result);
>  }
>  
>  void dlm_message_in(struct dlm_message *ms)
>  {
>  	header_in(&ms->m_header);
>  
> -	ms->m_type		= le32_to_cpu(ms->m_type);
> -	ms->m_nodeid		= le32_to_cpu(ms->m_nodeid);
> -	ms->m_pid		= le32_to_cpu(ms->m_pid);
> -	ms->m_lkid		= le32_to_cpu(ms->m_lkid);
> -	ms->m_remid		= le32_to_cpu(ms->m_remid);
> -	ms->m_parent_lkid	= le32_to_cpu(ms->m_parent_lkid);
> -	ms->m_parent_remid	= le32_to_cpu(ms->m_parent_remid);
> -	ms->m_exflags		= le32_to_cpu(ms->m_exflags);
> -	ms->m_sbflags		= le32_to_cpu(ms->m_sbflags);
> -	ms->m_flags		= le32_to_cpu(ms->m_flags);
> -	ms->m_lvbseq		= le32_to_cpu(ms->m_lvbseq);
> -	ms->m_hash		= le32_to_cpu(ms->m_hash);
> -	ms->m_status		= le32_to_cpu(ms->m_status);
> -	ms->m_grmode		= le32_to_cpu(ms->m_grmode);
> -	ms->m_rqmode		= le32_to_cpu(ms->m_rqmode);
> -	ms->m_bastmode		= le32_to_cpu(ms->m_bastmode);
> -	ms->m_asts		= le32_to_cpu(ms->m_asts);
> -	ms->m_result		= from_dlm_errno(le32_to_cpu(ms->m_result));
> +	le32_to_cpus(&ms->m_type);
> +	le32_to_cpus(&ms->m_nodeid);
> +	le32_to_cpus(&ms->m_pid);
> +	le32_to_cpus(&ms->m_lkid);
> +	le32_to_cpus(&ms->m_remid);
> +	le32_to_cpus(&ms->m_parent_lkid);
> +	le32_to_cpus(&ms->m_parent_remid);
> +	le32_to_cpus(&ms->m_exflags);
> +	le32_to_cpus(&ms->m_sbflags);
> +	le32_to_cpus(&ms->m_flags);
> +	le32_to_cpus(&ms->m_lvbseq);
> +	le32_to_cpus(&ms->m_hash);
> +	le32_to_cpus(&ms->m_status);
> +	le32_to_cpus(&ms->m_grmode);
> +	le32_to_cpus(&ms->m_rqmode);
> +	le32_to_cpus(&ms->m_bastmode);
> +	le32_to_cpus(&ms->m_asts);
> +	from_dlm_errno(&ms->m_result);
>  }
>  
>  void dlm_rcom_out(struct dlm_rcom *rc)
>  {
>  	header_out(&rc->rc_header);
>  
> -	rc->rc_type		= cpu_to_le32(rc->rc_type);
> -	rc->rc_result		= cpu_to_le32(rc->rc_result);
> -	rc->rc_id		= cpu_to_le64(rc->rc_id);
> -	rc->rc_seq		= cpu_to_le64(rc->rc_seq);
> -	rc->rc_seq_reply	= cpu_to_le64(rc->rc_seq_reply);
> +	cpu_to_le32s(&rc->rc_type);
> +	cpu_to_le32s(&rc->rc_result);
> +	cpu_to_le64s(&rc->rc_id);
> +	cpu_to_le64s(&rc->rc_seq);
> +	cpu_to_le64s(&rc->rc_seq_reply);
>  }
>  
>  void dlm_rcom_in(struct dlm_rcom *rc)
>  {
>  	header_in(&rc->rc_header);
>  
> -	rc->rc_type		= le32_to_cpu(rc->rc_type);
> -	rc->rc_result		= le32_to_cpu(rc->rc_result);
> -	rc->rc_id		= le64_to_cpu(rc->rc_id);
> -	rc->rc_seq		= le64_to_cpu(rc->rc_seq);
> -	rc->rc_seq_reply	= le64_to_cpu(rc->rc_seq_reply);
> +	le32_to_cpus(&rc->rc_type);
> +	le32_to_cpus(&rc->rc_result);
> +	le64_to_cpus(&rc->rc_id);
> +	le64_to_cpus(&rc->rc_seq);
> +	le64_to_cpus(&rc->rc_seq_reply);
>  }
> -- 
> 1.5.6.3.499.geae9
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
