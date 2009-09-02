Return-Path: <linux-kernel-owner+w=401wt.eu-S932130AbZIBEuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130AbZIBEuE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 00:50:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753461AbZIBEuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 00:50:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40134 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752892AbZIBEuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 00:50:02 -0400
Date: Tue, 1 Sep 2009 21:49:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
       "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH v2 1/2] cpu: Offline state Framework.
Message-Id: <20090901214935.bc505f9f.akpm@linux-foundation.org>
In-Reply-To: <20090828100016.10641.62621.stgit@sofia.in.ibm.com>
References: <20090828095741.10641.32053.stgit@sofia.in.ibm.com>
	<20090828100016.10641.62621.stgit@sofia.in.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Aug 2009 15:30:16 +0530 Gautham R Shenoy <ego@in.ibm.com> wrote:

> Provide an interface by which the system administrator can decide what state
> should the CPU go to when it is offlined.
> 
> To query the hotplug states, on needs to perform a read on the sysfs tunable:
> 	/sys/devices/system/cpu/cpu<number>/available_hotplug_states
> 
> To query or set the current state for a particular CPU, one needs to
> use the sysfs interface:
> 	/sys/devices/system/cpu/cpu<number>/current_state
> 
> This patch implements the architecture independent bits of the
> cpu-offline-state framework.
> 
> Architectures which want to expose the multiple offline-states to the
> userspace are expected to write a driver which can register
> with this framework.
> 
> Such a driver should:
> - Implement the callbacks defined in the structure struct cpu_offline_driver
>   which can be called into by this framework when the corresponding
>   sysfs interfaces are read or written into.
> 
> - Ensure that the following operation puts the CPU in the same state
>   as it did in the absence of the driver.
> 	echo 0 > /sys/devices/system/cpu/cpu<number>/online
> 
> This framework also serializes the writes to the "current_state"
> with respect to with the writes to the "online" sysfs tunable.
> 

It would be nice to document this new userspace interface somewhere.


> +struct cpu_offline_driver *cpu_offline_driver;
> +static DEFINE_MUTEX(cpu_offline_driver_lock);
> +
> +ssize_t show_available_states(struct sys_device *dev,
> +			struct sysdev_attribute *attr, char *buf)
> +{
> +	struct cpu *cpu = container_of(dev, struct cpu, sysdev);
> +	int cpu_num = cpu->sysdev.id;
> +	ssize_t ret;
> +
> +	mutex_lock(&cpu_offline_driver_lock);
> +	if (!cpu_offline_driver) {
> +		ret = -EEXIST;
> +		goto out_unlock;
> +	}
> +
> +	ret = cpu_offline_driver->read_available_states(cpu_num, buf);
> +
> +out_unlock:
> +	mutex_unlock(&cpu_offline_driver_lock);
> +
> +	return ret;
> +
> +}

The patch adds boatloads of global symbols which do not have names
which are appropriate for global symbols.

> +ssize_t show_current_state(struct sys_device *dev,
> +			struct sysdev_attribute *attr, char *buf)

Like that.

> +ssize_t store_current_state(struct sys_device *dev,
> +			struct sysdev_attribute *attr,
> +			const char *buf, size_t count)

And that.

> +
> +static SYSDEV_ATTR(available_hotplug_states, 0444, show_available_states,
> +								NULL);
> +static SYSDEV_ATTR(current_state, 0644, show_current_state,
> +						store_current_state);
> +
> +/* Should be called with cpu_offline_driver_lock held */
> +void cpu_offline_driver_add_cpu(struct sys_device *cpu_sys_dev)
> +{
> +	if (!cpu_offline_driver || !cpu_sys_dev)
> +		return;
> +
> +	sysdev_create_file(cpu_sys_dev, &attr_available_hotplug_states);
> +	sysdev_create_file(cpu_sys_dev, &attr_current_state);
> +}
> +
> +/* Should be called with cpu_offline_driver_lock held */
> +void cpu_offline_driver_remove_cpu(struct sys_device *cpu_sys_dev)
> +{
> +	if (!cpu_offline_driver || !cpu_sys_dev)
> +		return;
> +
> +	sysdev_remove_file(cpu_sys_dev, &attr_available_hotplug_states);
> +	sysdev_remove_file(cpu_sys_dev, &attr_current_state);
> +
> +}

Please don't just ignore possible error returns.

> +int register_cpu_offline_driver(struct cpu_offline_driver *arch_cpu_driver)
> +{
> +	int ret = 0;
> +	int cpu;
> +	mutex_lock(&cpu_offline_driver_lock);
> +

The blank line goes after end-of-locals and before start-of-code.

> +	if (cpu_offline_driver != NULL) {
> +		ret = -EEXIST;
> +		goto out_unlock;
> +	}
> +
> +	if (!(arch_cpu_driver->read_available_states &&
> +	      arch_cpu_driver->read_current_state &&
> +	      arch_cpu_driver->write_current_state)) {
> +		ret = -EINVAL;
> +		goto out_unlock;

This seems pretty pointless.  Just let the code oops - the developer
will notice fairly quickly.

> +	}
> +
> +	cpu_offline_driver = arch_cpu_driver;
> +
> +	for_each_possible_cpu(cpu)
> +		cpu_offline_driver_add_cpu(get_cpu_sysdev(cpu));
> +
> +out_unlock:
> +	mutex_unlock(&cpu_offline_driver_lock);
> +	return ret;
> +}
> +
> +void unregister_cpu_offline_driver(struct cpu_offline_driver *arch_cpu_driver)
> +{
> +	int cpu;
> +	mutex_lock(&cpu_offline_driver_lock);
> +
> +	if (!cpu_offline_driver) {
> +		WARN_ON(1);

	if (WARN_ON(!cpu_offline_driver)) {

> +		mutex_unlock(&cpu_offline_driver_lock);
> +		return;
> +	}
> +
> +	for_each_possible_cpu(cpu)
> +		cpu_offline_driver_remove_cpu(get_cpu_sysdev(cpu));
> +
> +	cpu_offline_driver = NULL;
> +	mutex_unlock(&cpu_offline_driver_lock);
> +}
> +
> +

