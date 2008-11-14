Return-Path: <linux-kernel-owner+w=401wt.eu-S1751957AbYKNWQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957AbYKNWQk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 17:16:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755328AbYKNWQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 17:16:27 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37852 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754801AbYKNWQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 17:16:25 -0500
Date: Fri, 14 Nov 2008 14:15:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com, jmorris@namei.org,
       hch@infradead.org, viro@ZenIV.linux.org.uk, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, zohar@us.ibm.com
Subject: Re: [PATCH 3/4] integrity: IMA as an integrity service provider
Message-Id: <20081114141515.325f6989.akpm@linux-foundation.org>
In-Reply-To: <6ce62b4aac47ea9b2189aa5b6149008b99324c34.1226547085.git.zohar@linux.vnet.ibm.com>
References: <cover.1226547084.git.zohar@linux.vnet.ibm.com>
	<6ce62b4aac47ea9b2189aa5b6149008b99324c34.1226547085.git.zohar@linux.vnet.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2008 22:47:13 -0500
Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> This is a re-release of Integrity Measurement Architecture(IMA) as an
> independent Linunx Integrity Module(LIM) service provider.
> 
> As a LIM integrity provider, IMA implements the new LIM must_measure(),
> collect_measurement(), store_measurement(), and display_template() API
> calls. The store_measurement() call supports two types of data, IMA
> (i.e. file data) and generic template data.
> 
> IMA provides hardware (TPM) based measurement and attestation for both
> files and other types of template measurements. As the Trusted Computing
> (TPM) model requires, IMA measures all files before they are accessed
> in any way (on the bprm_check_integrity, nameidata_check_integrity,
> file_mmap hooks), and commits the measurements to the TPM.  In addition,
> IMA maintains a list of these hash values, which can be used to validate
> the aggregate PCR value.  The TPM can sign these measurements, and thus
> the system can prove to itself and to a third party these measurements
> in a way that cannot be circumvented by malicious or compromised software.
> 
> When store_measurement() is called for the IMA type of data, the file
> measurement and the file name hint are used to form an IMA template.
> IMA then calculates the IMA template measurement(hash) and submits it
> to the TPM chip for inclusion in one of the chip's Platform Configuration
> Registers (PCR).
> 
> When store_measurement() is called for generic template data, IMA
> calculates the measurement(hash) of the template data, and submits
> the template measurement to the TPM chip for inclusion in one of the
> chip's Platform Configuration Registers(PCR).
> 
> In order to view the contents of template data through securityfs, the
> template_display() function must be defined in the registered
> template_operations.  In the case of the IMA template, the list of
> file names and files hashes submitted can be viewed through securityfs.
> 
> As mentioned above, IMA maintains a list of hash values of executables
> and other sensitive system files loaded into the run-time of the system.
> Our work has shown that requests for integrity appraisal and measurement
> need to be based on knowledge of the filesystem, requiring the system
> to either be labeled with integrity data or depend on the existent LSM
> security labels.  The previous set of integrity patches modified the LSM
> modules to be integrity context aware, meaning that the LSM modules made
> integrity data/metadata appraisal and measurement API calls based on
> an understanding of the LSM security labels.  Both of the LSM maintainers
> felt that the changes were too intrusive and that integrity enforcement
> should be made by the integrity provider, not the LSM module.
> 
> To address these concerns, Stephen Smalley suggested using the
> security_audit_rule_match(), renamed to security_filter_rule_match(), to
> define LSM specific integrity measurement policy rules, in lieu of
> modifying the LSM modules.  In the current set of patches, the integrity
> API calls can be made either by IMA, based on an LSM specific integrity
> policy, or by an integrity context aware LSM.
> 
> ...
>
> +static void ima_add_boot_aggregate(void)
> +{
> +	/* cumulative sha1 over tpm registers 0-7 */
> +	struct ima_measure_entry *entry;
> +	size_t count;
> +	int err;
> +
> +	/* create new entry for boot aggregate */
> +	entry = kzalloc(sizeof(*entry), GFP_ATOMIC);

This uses GFP_ATOMIC, but crypto_alloc_hash() (called later) uses
GFP_KERNEL.

If this _had_ to be GFP_ATOMIC then you have a bug.

Otherwise, please use the much more reliable GFP_KERNEL here.


